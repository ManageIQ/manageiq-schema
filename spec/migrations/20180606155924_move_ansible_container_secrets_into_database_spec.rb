require_migration

describe MoveAnsibleContainerSecretsIntoDatabase do
  let(:database_stub)       { migration_stub(:MiqDatabase) }
  let(:authentication_stub) { migration_stub(:Authentication) }
  let(:db_id)               { database_stub.first.id }

  let(:cert)       { Tempfile.new("cert") }
  let(:token)      { Tempfile.new("token") }
  let(:cert_path)  { cert.path }
  let(:token_path) { token.path }
  let(:kube_host)  { "kube.example.com" }
  let(:kube_port)  { "8443" }
  let(:namespace)  { "manageiq" }

  before do
    database_stub.create!

    ENV["KUBERNETES_SERVICE_HOST"] = kube_host
    ENV["KUBERNETES_SERVICE_PORT"] = kube_port
    ENV["MY_POD_NAMESPACE"] = namespace
  end

  after do
    FileUtils.rm_f(cert_path)
    FileUtils.rm_f(token_path)
    ENV.delete("KUBERNETES_SERVICE_HOST")
    ENV.delete("KUBERNETES_SERVICE_PORT")
    ENV.delete("MY_POD_NAMESPACE")
  end

  migration_context :up do
    it "doesn't add any authentications if not running in a container" do
      migrate
      expect(database_authentications.count).to eq(0)
    end

    context "with an API connection in a container" do
      let(:uri_stub) { double("URI") }
      let(:secret_json) do
        {
          "kind"       => "Secret",
          "apiVersion" => "v1",
          "metadata"   => {
            "name"      => "ansible-secrets",
            "namespace" => namespace,
            "labels"    => {
              "app"      => "manageiq",
              "template" => "manageiq"
            },
          },
          "data"       => {
            "admin-password"  => "YWRtaW5wYXNzd29yZA==",
            "rabbit-password" => "cmFiYml0cGFzc3dvcmQ=",
            "secret-key"      => "c2VjcmV0a2V5"
          },
          "type"       => "Opaque"
        }.to_json
      end

      before do
        stub_const("MoveAnsibleContainerSecretsIntoDatabase::TOKEN_FILE", token_path)
        stub_const("MoveAnsibleContainerSecretsIntoDatabase::CA_CERT_FILE", cert_path)
        expect(URI::HTTPS).to receive(:build).with(
          :host => kube_host,
          :port => kube_port,
          :path => "/api/v1/namespaces/#{namespace}/secrets/ansible-secrets"
        ).and_return(uri_stub)
      end

      it "doesn't add any authentications if the secret is not found" do
        require 'open-uri'
        error = OpenURI::HTTPError.new("404 Not Found", nil)
        expect(uri_stub).to receive(:open).and_raise(error)

        migrate

        expect(database_authentications.count).to eq(0)
      end

      it "creates new authentications for the secret values" do
        expect_request
        migrate

        expect(database_authentications.count).to eq(4)
        expect(ansible_secret_key).to eq("secretkey")
        expect(ansible_rabbitmq_password).to eq("rabbitpassword")
        expect(ansible_database_password).to eq(ApplicationRecord.configurations[Rails.env]["password"])
      end

      it "updates authentications with the secret values" do
        expect_request
        authentication_stub.create!(
          :name          => "Ansible Secret Key",
          :authtype      => "ansible_secret_key",
          :type          => "AuthToken",
          :auth_key      => ManageIQ::Password.encrypt("notthekey"),
          :resource_id   => db_id,
          :resource_type => "MiqDatabase"
        )
        expect(ansible_secret_key).to eq("notthekey")

        migrate

        expect(ansible_secret_key).to eq("secretkey")
        expect(ansible_rabbitmq_password).to eq("rabbitpassword")
        expect(ansible_admin_password).to eq("adminpassword")
        expect(ansible_database_password).to eq(ApplicationRecord.configurations[Rails.env]["password"])
      end
    end
  end

  def expect_request
    expect(File).to receive(:read).with(token_path).and_return("totally-a-token")
    response = double("RequestIO", :read => secret_json)
    expect(uri_stub).to receive(:open).with(
      'Accept'         => "application/json",
      'Authorization'  => "Bearer totally-a-token",
      :ssl_ca_cert     => cert_path,
      :ssl_verify_mode => OpenSSL::SSL::VERIFY_PEER
    ).and_yield(response)
  end

  def database_authentications
    authentication_stub.where(:resource_id => db_id, :resource_type => "MiqDatabase")
  end

  def ansible_secret_key
    auths = database_authentications.where(
      :name     => "Ansible Secret Key",
      :authtype => "ansible_secret_key",
      :type     => "AuthToken"
    )
    expect(auths.count).to eq(1)
    ManageIQ::Password.decrypt(auths.first.auth_key)
  end

  def ansible_rabbitmq_password
    auths = database_authentications.where(
      :name     => "Ansible Rabbitmq Authentication",
      :authtype => "ansible_rabbitmq_auth",
      :userid   => "ansible",
      :type     => "AuthUseridPassword"
    )
    expect(auths.count).to eq(1)
    ManageIQ::Password.decrypt(auths.first.password)
  end

  def ansible_admin_password
    auths = database_authentications.where(
      :name     => "Ansible Admin Authentication",
      :authtype => "ansible_admin_password",
      :userid   => "admin",
      :type     => "AuthUseridPassword"
    )
    expect(auths.count).to eq(1)
    ManageIQ::Password.decrypt(auths.first.password)
  end

  def ansible_database_password
    auths = database_authentications.where(
      :name     => "Ansible Database Authentication",
      :authtype => "ansible_database_password",
      :userid   => ApplicationRecord.configurations[Rails.env]["username"],
      :type     => "AuthUseridPassword"
    )
    expect(auths.count).to eq(1)
    ManageIQ::Password.decrypt(auths.first.password)
  end
end
