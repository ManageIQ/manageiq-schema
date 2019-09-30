class MoveAwxCredentialsToAuthentications < ActiveRecord::Migration[5.0]
  class Authentication < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
    serialize :options
  end

  # This class is port of the code found in both the awx code base, and the
  # python cryptography library:
  #
  #   https://github.com/pyca/cryptography/blob/ed5a7717/src/cryptography/fernet.py
  #   https://github.com/ansible/awx/blob/4788f0814/awx/main/utils/encryption.py
  #
  # The only real portions from this that are from the `awx` side are for the
  # inheriting `Fernet256` from the pythons cryptography lib's `Fernet` class:
  #
  #   https://github.com/ansible/awx/blob/4788f081/awx/main/utils/encryption.py#L20-L23
  #
  # The rest pretty much emulates code from cryptography.py
  class Fernet256
    attr_reader :hmac, :cipher, :signing_key, :encryption_key

    InvalidToken = Class.new(ArgumentError)

    # This initialize method is mostly pulled from from the ansible override of
    # the base Fernet library.
    #
    #   https://github.com/ansible/awx/blob/4788f0814/awx/main/utils/encryption.py#L24-L35
    #
    # The backend is always going to be `OpenSSL` for us, so that is
    # irrelevant, but everything else is mostly as it is on the python
    # equivalent.
    #
    # The only diverging change was that we initialize the @cipher and @hmac (for
    # verification) here instead of in the methods that use them (found in the
    # `cryptography` base class).
    #
    def initialize(key)
      decoded_key = Base64.urlsafe_decode64(key)
      if decoded_key.size != 64
        raise ArgumentError, "Fernet key must be 64 url-safe base64-encoded bytes."
      end

      @signing_key    = decoded_key[0,32]
      @encryption_key = decoded_key[32,32]

      @cipher = OpenSSL::Cipher::AES256.new(:CBC)
      @hmac   = OpenSSL::HMAC.new signing_key, OpenSSL::Digest::SHA256.new
    end

    # This is from the main bulk of the Fernet#decrypt method in the
    # cryptography python lib:
    #
    #   https://github.com/pyca/cryptography/blob/ed5a7717/src/cryptography/fernet.py#L105-L122
    #
    # The verify bit will be described below, but the bulk of what is in the
    # cryptography lib can simply be replaced with the cipher decrypt
    # functionality in Ruby's OpenSSL implementation.
    #
    # Since the fernet lib is also in charge of a decent amount of FFI
    # interplay that the OpenSSL equivalent in Ruby takes care of for us in
    # its C implementation directly, so if this looks a bit simpler, that is
    # because it is.
    #
    # Of note from the above:  Because of how the string slicing works in
    # python and differs from the notation in ruby, there looks to be "off by
    # one" errors all over the place, but that is intentional.  For example,
    # for the `cipher.iv` assignment, in python it is:
    #
    #   iv = data[9:25]
    #
    # Which translates to "start at the 9th char, and bring back everything to
    # the 25 char", where in ruby it is:
    #
    #   iv = data[9,16]
    #
    # "bring back 16 characters starting from the 9th char".  There is no ":"
    # notation available, a equivalent translation had to be made.
    def decrypt(token)
      data = Base64.urlsafe_decode64(token)
      verify data

      cipher.decrypt
      cipher.iv  = data[9,16]
      cipher.key = encryption_key
      ciphertext = data[25..-33]

      decrypted  = cipher.update ciphertext
      decrypted << cipher.final
    end

    private

    # This method is a smaller portion of the Fernet#decrypt method from the
    # cryptography python lib:
    #
    #   https://github.com/pyca/cryptography/blob/ed5a7717/src/cryptography/fernet.py#L98-L103
    #
    # And for the most part, is equivalent in nature.
    #
    # The big thing of note is the `hmac.digest == signature` portion, which is
    # slightly "less secure" in this implementation.  I say that since the
    # `.verify` implementation in the python version from above does a
    # `constant_time.bytes_eq` call:
    #
    #   https://github.com/pyca/cryptography/blob/ed5a7717/src/cryptography/hazmat/backends/openssl/hmac.py#L70-L73
    #
    # Which is a timing attack prevention measure.  There currently isn't a
    # ruby equivalent available, but one is in the works:
    #
    #   https://bugs.ruby-lang.org/issues/10098
    #
    # Probably not relevant for a migration, but it is worth noting in case the
    # is confusing about where the `.verify` method comes from in the python
    # implementation.
    def verify(data)
      hmac << data[0..-33]
      signature = data[-32..-1]
      return if hmac.digest == signature
      raise InvalidToken
    end
  end

  # Wrapper class that mostly emulates what is done in awx's
  # utils/encryption.py library:
  #
  #   https://github.com/ansible/awx/blob/4788f081/awx/main/utils/encryption.py
  #
  class AnsibleDecrypt
    attr_reader :encryption_key, :encrypted_data

    # Convenience method for `#decrypt`, and avoids having to pass along the
    # `secret_key` every time, and allows it to be memoized on the class
    # itself.
    def self.decrypt(field_name, value, primary_key)
      require 'openssl'
      require 'base64'

      return value unless value.include?("$encrypted$")

      new(secret_key, value, field_name, primary_key).decrypt
    rescue Fernet256::InvalidToken
      raise unless ENV["HARDCODE_ANSIBLE_PASSWORD"]

      ENV["HARDCODE_ANSIBLE_PASSWORD"]
    end

    def self.secret_key
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

    # Mostly a implementation of decrypt_field from utils/encryption.py found
    # in the awx codebase:
    #
    #   https://github.com/ansible/awx/blob/4788f081/awx/main/utils/encryption.py#L97
    #
    # Restructed a bit differently for our purposes, but a separate call to
    # `#decrypt` is required to finish the decryption.
    def initialize(secret_key, value, field_name, primary_key)
      @encryption_key = get_encryption_key(secret_key, field_name, primary_key)
      @encrypted_data = parse_raw_data(value)
    end

    def decrypt
      Fernet256.new(encryption_key).decrypt(encrypted_data).force_encoding('utf-8').chomp
    end

    private

    # Pulled from the awx utils/encryption.py code's `.get_encryption_key`
    # almost directly:
    #
    #   https://github.com/ansible/awx/blob/4788f081/awx/main/utils/encryption.py#L49-L54
    #
    # The python `hashlib.sha512` translates to a `OpenSSL::Digest::SHA512`
    # directly, and the only difference is this code makes use of the `.<<`
    # instead of update since they are equivalent in Ruby.
    #
    # Calls to `smart_str` and `smart_bytes` are not needed in the ruby
    # equivalent as the Ruby libraries can easily translate between byte arrays
    # and strings easily, so that is a python implementation detail that is not
    # necessary for Ruby.
    def get_encryption_key(secret, field, pk=nil)
      key_hash  = OpenSSL::Digest::SHA512.new
      key_hash << secret
      key_hash << pk if pk
      key_hash << field
      Base64.urlsafe_encode64(key_hash.digest)
    end

    # Pulled from a portion of the the awx utils/encryption.py code's
    # `.decrypt_value` method:
    #
    #   https://github.com/ansible/awx/blob/4788f081/awx/main/utils/encryption.py#L82-L91
    #
    # In this case, the `len('$encrypted$')` and `len('UTF8$')` have been
    # hardcoded as "magic numbers" directly, but the core of that code is
    # mostly the same.
    #
    # The call to Fernet256 following the equivalent code for this method in
    # the above linked python code is done in the `AnsibleDecrypt#decrypt`
    # method instead, and this is called as part of the `initialize` for an
    # instance of this class.
    def parse_raw_data(value)
      raw_data = value[11..-1]
      raw_data = raw_data[5..-1] if raw_data.start_with?('UTF8$')

      algorithm, base64_data = raw_data.split('$', 2)

      if algorithm != 'AESCBC'
        raise Fernet256::InvalidToken, "unsupported algorithm: #{algorithm}"
      end

      Base64.decode64(base64_data)
    end
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

      say_with_time("Migrating credential #{auth.name} from AWX to vmdb") do
        awx_info = awx_credential_info(auth.manager_ref)
        update_authentication(auth, awx_info)
      end
    end
  rescue PG::ConnectionBad
    say("AWX database is unreachable, credentials cannot be migrated")
  rescue Fernet256::InvalidToken
    say("AWX password invalid, credentials cannot be migrated!")
    say("")
    say("This is often the case when migrating a database that was backed up")
    say("and then restored and fix_auth has reset the ansible secret key")
    say("")
    say("If you want to continue and set all the invalid passwords to a")
    say("preknown 'dummy' value then run migrate again with:")
    say("")
    say("   $ $HARDCODE_ANSIBLE_PASSWORD=bogus")
    say("")
    raise
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
      decrypted_value          = AnsibleDecrypt.decrypt(k, v, auth.manager_ref)
      new_value                = ENCRYPTED_ATTRIBUTES.include?(authentication_attribute) ? ManageIQ::Password.encrypt(decrypted_value) : decrypted_value

      if authentication_attribute
        auth.send("#{authentication_attribute}=", new_value)
      else
        say("Unknown credential field #{k}, ignoring")
      end
    end
    auth.manager_ref = auth.id.to_s
    auth.save!
  end
end
