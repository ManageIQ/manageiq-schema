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
      before do
        stub_const("MoveAnsibleContainerSecretsIntoDatabase::TOKEN_FILE", token_path)
        stub_const("MoveAnsibleContainerSecretsIntoDatabase::CA_CERT_FILE", cert_path)
      end

      let(:kube_connection) { subject.send(:kube_connection) }
      let(:oc_connection) { subject.send(:oc_connection) }

      it "creates the correct kube connection" do
        expect(kube_connection.api_endpoint.to_s).to eq("https://kube.example.com:8443/api")
        expect(kube_connection.auth_options[:bearer_token_file]).to eq(token_path)
        expect(kube_connection.ssl_options[:verify_ssl]).to eq(1)
      end

      it "creates the correct oc connection" do
        expect(oc_connection.api_endpoint.to_s).to eq("https://kube.example.com:8443/oapi")
        expect(oc_connection.auth_options[:bearer_token_file]).to eq(token_path)
        expect(oc_connection.ssl_options[:verify_ssl]).to eq(1)
      end

      context "with stub connection" do
        let(:connection_stub) { double("KubeConnection") }
        let(:secret) do
          OpenStruct.new(:data => {
            :"admin-password" => "YWRtaW5wYXNzd29yZA==",
            :"rabbit-password" => "cmFiYml0cGFzc3dvcmQ=",
            :"secret-key" => "c2VjcmV0a2V5"
          })
        end

        before do
          allow(Kubeclient::Client).to receive(:new).and_return(connection_stub)
          expect_objects_deleted
        end

        it "doesn't add any authentications if the secret is not found" do
          error = KubeException.new(404, "secret not found", "")
          expect(connection_stub).to receive(:get_secret).and_raise(error)

          migrate

          expect(database_authentications.count).to eq(0)
        end

        it "creates new authentications for the secret values" do
          expect(connection_stub).to receive(:get_secret).with("ansible-secrets", namespace).and_return(secret)
          migrate

          expect(database_authentications.count).to eq(3)
          expect(ansible_secret_key).to eq("secretkey")
          expect(ansible_rabbitmq_password).to eq("rabbitpassword")
          expect(ansible_database_password).to eq(ApplicationRecord.configurations[Rails.env]["password"])
        end

        it "updates authentications with the secret values" do
          expect(connection_stub).to receive(:get_secret).with("ansible-secrets", namespace).and_return(secret)
          authentication_stub.create!(
            :name          => "Ansible Secret Key",
            :authtype      => "ansible_secret_key",
            :type          => "AuthToken",
            :auth_key      => MiqPassword.encrypt("notthekey"),
            :resource_id   => db_id,
            :resource_type => "MiqDatabase"
          )
          expect(ansible_secret_key).to eq("notthekey")

          migrate

          expect(ansible_secret_key).to eq("secretkey")
          expect(ansible_rabbitmq_password).to eq("rabbitpassword")
          expect(ansible_database_password).to eq(ApplicationRecord.configurations[Rails.env]["password"])
        end
      end
    end
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
    MiqPassword.decrypt(auths.first.auth_key)
  end

  def ansible_rabbitmq_password
    auths = database_authentications.where(
      :name     => "Ansible Rabbitmq Authentication",
      :authtype => "ansible_rabbitmq_auth",
      :userid   => "ansible",
      :type     => "AuthUseridPassword"
    )
    expect(auths.count).to eq(1)
    MiqPassword.decrypt(auths.first.password)
  end

  def ansible_database_password
    auths = database_authentications.where(
      :name     => "Ansible Database Authentication",
      :authtype => "ansible_database_password",
      :userid   => ApplicationRecord.configurations[Rails.env]["username"],
      :type     => "AuthUseridPassword"
    )
    expect(auths.count).to eq(1)
    MiqPassword.decrypt(auths.first.password)
  end

  def expect_objects_deleted
    # deletes deployment and repliction controller
    expect(connection_stub).to receive(:get_replication_controllers).with(
      :label_selector => "openshift.io/deployment-config.name=ansible",
      :namespace      => namespace
    ).and_return([double(:metadata => double(:name => "testrepcontroller"))])
    expect(connection_stub).to receive(:patch_deployment_config).with("ansible", {:spec => {:replicas => 0}}, namespace)
    expect(connection_stub).to receive(:delete_deployment_config).with("ansible", namespace)
    expect(connection_stub).to receive(:delete_replication_controller).with("testrepcontroller", namespace)

    # deletes service
    expect(connection_stub).to receive(:delete_service).with("ansible", namespace)

    # deletes secret
    expect(connection_stub).to receive(:delete_secret).with("ansible-secrets", namespace)
  end
end
