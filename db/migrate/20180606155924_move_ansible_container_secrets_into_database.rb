class MoveAnsibleContainerSecretsIntoDatabase < ActiveRecord::Migration[5.0]
  require 'kubeclient'

  TOKEN_FILE   = "/run/secrets/kubernetes.io/serviceaccount/token".freeze
  CA_CERT_FILE = "/run/secrets/kubernetes.io/serviceaccount/ca.crt".freeze
  SECRET_NAME  = "ansible-secrets".freeze
  SERVICE_NAME = "ansible".freeze

  class MiqDatabase < ActiveRecord::Base; end

  class Authentication < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    return unless containerized?
    update_authentications
    delete_deployment_config(SERVICE_NAME)
    delete_service(SERVICE_NAME)
    delete_secret(SECRET_NAME)
  end

  private

  def containerized?
    File.exist?(TOKEN_FILE) && File.exist?(CA_CERT_FILE)
  end

  def update_authentications
    secret_key, rabbit_password, database_password = get_secret_data

    return unless secret_key.present? && rabbit_password.present?

    db_id = MiqDatabase.first.id
    db_args = {
      :resource_id   => db_id,
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
    database_auth_find_args = db_args.merge(
      :name     => "Ansible Database Authentication",
      :authtype => "ansible_database_password",
      :userid   => ApplicationRecord.configurations[Rails.env]["username"],
      :type     => "AuthUseridPassword"
    )

    update_or_create_authentication!(secret_key_find_args, :auth_key => secret_key)
    update_or_create_authentication!(rabbitmq_auth_find_args, :password => rabbit_password)
    update_or_create_authentication!(database_auth_find_args, :password => database_password)
  end

  def get_secret_data
    kube_data = kube_connection.get_secret(SECRET_NAME, my_namespace).data
    decrypted_data = kube_data.to_h.stringify_keys.transform_values { |v| Base64.decode64(v) }

    [decrypted_data["secret-key"], decrypted_data["rabbit-password"], ApplicationRecord.configurations[Rails.env]["password"]].map { |v| MiqPassword.encrypt(v) }
  rescue KubeException => e
    raise unless e.error_code == 404
    nil
  end

  def update_or_create_authentication!(find_args, update_args)
    auth = Authentication.find_or_initialize_by(find_args)
    auth.update_attributes!(update_args)
  end

  def delete_deployment_config(name)
    rc = kube_connection.get_replication_controllers(
      :label_selector => "openshift.io/deployment-config.name=#{name}",
      :namespace      => my_namespace
    ).first

    oc_connection.patch_deployment_config(name, { :spec => { :replicas => 0 } }, my_namespace)
    oc_connection.delete_deployment_config(name, my_namespace)
    delete_replication_controller(rc.metadata.name) if rc
  rescue KubeException => e
    raise unless e.error_code == 404
  end

  def delete_replication_controller(name)
    kube_connection.delete_replication_controller(name, my_namespace)
  rescue KubeException => e
    raise unless e.error_code == 404
  end

  def delete_service(name)
    kube_connection.delete_service(name, my_namespace)
  rescue KubeException => e
    raise unless e.error_code == 404
  end

  def delete_secret(name)
    kube_connection.delete_secret(name, my_namespace)
  rescue KubeException => e
    raise unless e.error_code == 404
  end

  def oc_connection
    @oc_connection ||= raw_connect(manager_uri("/oapi"))
  end

  def kube_connection
    @kube_connection ||= raw_connect(manager_uri("/api"))
  end

  def raw_connect(uri)
    ssl_options = {
      :verify_ssl => OpenSSL::SSL::VERIFY_PEER,
      :ca_file    => CA_CERT_FILE
    }

    Kubeclient::Client.new(
      uri,
      :auth_options => { :bearer_token_file => TOKEN_FILE },
      :ssl_options  => ssl_options
    )
  end

  def manager_uri(path)
    URI::HTTPS.build(
      :host => ENV["KUBERNETES_SERVICE_HOST"],
      :port => ENV["KUBERNETES_SERVICE_PORT"],
      :path => path
    )
  end

  def my_namespace
    ENV["MY_POD_NAMESPACE"]
  end
end
