class MoveAnsibleContainerSecretsIntoDatabase < ActiveRecord::Migration[5.0]
  TOKEN_FILE   = "/run/secrets/kubernetes.io/serviceaccount/token".freeze
  CA_CERT_FILE = "/run/secrets/kubernetes.io/serviceaccount/ca.crt".freeze
  SECRET_NAME  = "ansible-secrets".freeze

  class MiqDatabase < ActiveRecord::Base; end

  class Authentication < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    return unless containerized?
    update_authentications
  end

  private

  def containerized?
    File.exist?(TOKEN_FILE) && File.exist?(CA_CERT_FILE)
  end

  def update_authentications
    secret_key, rabbit_password, admin_password, database_password = get_secret_data

    return unless secret_key.present? && rabbit_password.present? && admin_password.present?

    db_args = {
      :resource_id   => MiqDatabase.first.id,
      :resource_type => "MiqDatabase"
    }

    secret_key_find_args = db_args.merge(
      :name     => "Ansible Secret Key",
      :authtype => "ansible_secret_key",
      :type     => "AuthToken"
    )
    rabbitmq_auth_find_args = db_args.merge(
      :name     => "Ansible Rabbitmq Authentication",
      :authtype => "ansible_rabbitmq_auth",
      :userid   => "ansible",
      :type     => "AuthUseridPassword"
    )
    admin_auth_find_args = db_args.merge(
      :name     => "Ansible Admin Authentication",
      :authtype => "ansible_admin_password",
      :userid   => "admin",
      :type     => "AuthUseridPassword"
    )
    database_auth_find_args = db_args.merge(
      :name     => "Ansible Database Authentication",
      :authtype => "ansible_database_password",
      :userid   => ApplicationRecord.configurations[Rails.env]["username"],
      :type     => "AuthUseridPassword"
    )

    update_or_create_authentication!(secret_key_find_args, :auth_key => secret_key)
    update_or_create_authentication!(rabbitmq_auth_find_args, :password => rabbit_password)
    update_or_create_authentication!(admin_auth_find_args, :password => admin_password)
    update_or_create_authentication!(database_auth_find_args, :password => database_password)
  end

  def get_secret_data
    require 'open-uri'
    require 'json'

    kube_data = secret_uri.open(request_params) do |f|
      JSON.parse(f.read)["data"]
    end

    decoded_data = kube_data.transform_values { |v| Base64.decode64(v) }

    [
      decoded_data["secret-key"],
      decoded_data["rabbit-password"],
      decoded_data["admin-password"],
      ApplicationRecord.configurations[Rails.env]["password"]
    ].map { |v| ManageIQ::Password.encrypt(v) }
  rescue OpenURI::HTTPError
    nil
  end

  def update_or_create_authentication!(find_args, update_args)
    auth = Authentication.find_or_initialize_by(find_args)
    auth.update_attributes!(update_args)
  end

  def request_params
    {
      'Accept'         => "application/json",
      'Authorization'  => "Bearer #{File.read(TOKEN_FILE)}",
      :ssl_ca_cert     => CA_CERT_FILE,
      :ssl_verify_mode => OpenSSL::SSL::VERIFY_PEER
    }
  end

  def secret_uri
    URI::HTTPS.build(
      :host => ENV["KUBERNETES_SERVICE_HOST"],
      :port => ENV["KUBERNETES_SERVICE_PORT"],
      :path => "/api/v1/namespaces/#{ENV["MY_POD_NAMESPACE"]}/secrets/#{SECRET_NAME}"
    )
  end
end
