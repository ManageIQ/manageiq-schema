class MoveAwxCredentialsToAuthentications < ActiveRecord::Migration[5.0]
  class Authentication < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
    serialize :options
  end

  class MiqDatabase < ActiveRecord::Base; end

  ENCRYPTED_ATTRIBUTES = %w[
    auth_key
    auth_key_password
    become_password
    password
  ].freeze

  FIELD_MAP = {
    'authorize_password' => 'become_password',
    'become_username'    => 'become_username',
    'become_password'    => 'become_password',
    'password'           => 'password',
    'secret'             => 'auth_key',
    'security_token'     => 'auth_key',
    'ssh_key_data'       => 'auth_key',
    'ssh_key_unlock'     => 'auth_key_password',
    'username'           => 'userid',
    'vault_password'     => 'password'
  }.freeze

  OPTIONS_FIELDS = %w[
    authorize
    become_method
    client
    domain
    host
    project
    subscription
    tenant
  ].freeze

  def up
    embedded_ansible_authentications.each do |auth|
      if auth.manager_ref.nil?
        say("Skipping authentication #{auth.id} with nil manager ref")
        next
      end

      say_with_time("Migrating credential #{auth.name} from awx to vmdb") do
        awx_info = awx_credential_info(auth.manager_ref)
        update_authentication(auth, awx_info)
      end
    end
  rescue PG::ConnectionBad
    say("awx database is unreachable, credentials cannot be migrated")
  end

  private

  def embedded_ansible_authentications
    types = %w[
      ManageIQ::Providers::EmbeddedAnsible::AutomationManager::Credential
      ManageIQ::Providers::EmbeddedAnsible::AutomationManager::CloudCredential
      ManageIQ::Providers::EmbeddedAnsible::AutomationManager::MachineCredential
      ManageIQ::Providers::EmbeddedAnsible::AutomationManager::NetworkCredential
      ManageIQ::Providers::EmbeddedAnsible::AutomationManager::ScmCredential
      ManageIQ::Providers::EmbeddedAnsible::AutomationManager::VaultCredential
      ManageIQ::Providers::EmbeddedAnsible::AutomationManager::AmazonCredential
      ManageIQ::Providers::EmbeddedAnsible::AutomationManager::AzureCredential
      ManageIQ::Providers::EmbeddedAnsible::AutomationManager::GoogleCredential
      ManageIQ::Providers::EmbeddedAnsible::AutomationManager::OpenstackCredential
      ManageIQ::Providers::EmbeddedAnsible::AutomationManager::RhvCredential
      ManageIQ::Providers::EmbeddedAnsible::AutomationManager::VmwareCredential
    ]
    Authentication.in_my_region.where(:type => types)
  end

  def awx_credential_info(awx_id)
    cred_info = awx_connection.async_exec("SELECT inputs FROM main_credential WHERE id = $1::BIGINT", [awx_id]).first
    # in case there is no matching credential on the awx side
    return {} unless cred_info

    JSON.parse(cred_info["inputs"])
  end

  def awx_connection
    @awx_connection ||= PG::Connection.new(ApplicationRecord.connection.raw_connection.conninfo_hash.merge(:dbname => "awx").delete_blanks)
  end

  def update_authentication(auth, awx_info)
    auth.options = auth.options.slice(*OPTIONS_FIELDS.map(&:to_sym)).presence if auth.options

    awx_info.each do |k, v|
      if OPTIONS_FIELDS.include?(k)
        auth.options ||= {}
        auth.options[k.to_sym] = v
        next
      end

      authentication_attribute = FIELD_MAP[k]
      decrypted_value          = decrypted_awx_value(k, v, auth.manager_ref)
      new_value                = ENCRYPTED_ATTRIBUTES.include?(authentication_attribute) ? ManageIQ::Password.encrypt(decrypted_value) : decrypted_value

      if authentication_attribute
        auth.send("#{authentication_attribute}=", new_value)
      else
        say("Unknown credential field #{k}, ignoring")
      end
    end
    auth.save!
  end

  def decrypted_awx_value(field, value, pk)
    require 'awesome_spawn'

    return value unless value.include?("$encrypted$")

    env = {
      "FIELD_NAME"  => field,
      "VALUE"       => value,
      "SECRET_KEY"  => secret_key,
      "PRIMARY_KEY" => pk
    }
    result = AwesomeSpawn.run("python3", :params => [script_path], :env => env)

    raise "Failed to decrypt #{field} for credential #{pk}" if result.failure?

    result.output.chomp
  end

  def script_path
    @script_path ||= Pathname.new(__dir__).join("data", File.basename(__FILE__, ".rb")).join("standalone_decrypt.py").to_s
  end

  def secret_key
    @secret_key ||= begin
      key = Authentication.find_by(
        :resource_id   => MiqDatabase.first.id,
        :resource_type => "MiqDatabase",
        :name          => "Ansible Secret Key",
        :authtype      => "ansible_secret_key",
        :type          => "AuthToken"
      ).auth_key
      ManageIQ::Password.decrypt(key)
    end
  end
end
