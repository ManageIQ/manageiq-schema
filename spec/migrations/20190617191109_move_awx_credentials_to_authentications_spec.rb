require_migration
require 'awesome_spawn'
require 'json'
require 'yaml'

describe MoveAwxCredentialsToAuthentications do
  let(:data_dir) { Pathname.new(__dir__).join("data", File.basename(__FILE__, ".rb")) }

  let(:authentication) { migration_stub(:Authentication) }
  let(:miq_database)   { migration_stub(:MiqDatabase) }

  let(:secret_key)      { "ecad5764714a254a619d74ccc1c4387b" }
  let(:miq_database_id) { miq_database.create.id }

  before do
    authentication.create!(
      :name          => "Ansible Secret Key",
      :authtype      => "ansible_secret_key",
      :resource_id   => miq_database_id,
      :resource_type => "MiqDatabase",
      :type          => "AuthToken",
      :auth_key      => ManageIQ::Password.encrypt(secret_key)
    )
  end

  migration_context :up do
    it "doesn't try to migrate authentications without a manager ref" do
      auth = authentication.create!(
        :name => "no_manager_ref",
        :type => "ManageIQ::Providers::EmbeddedAnsible::AutomationManager::VaultCredential"
      )
      expect(auth.manager_ref).to be_nil
      expect(PG::Connection).to_not receive(:new)

      migrate
    end

    it "only migrates EmbeddedAnsible credentials" do
      authentication.create!(
        :name        => "ansible_tower_credential",
        :type        => "ManageIQ::Providers::AnsibleTower::AutomationManager::GoogleCredential",
        :manager_ref => "1"
      )
      expect(PG::Connection).to_not receive(:new)

      migrate
    end

    it "is successful if we can't connect to the awx database" do
      authentication.create!(
        :name        => "machine_credential",
        :type        => "ManageIQ::Providers::EmbeddedAnsible::AutomationManager::MachineCredential",
        :userid      => "",
        :options     => {:become_method => ""},
        :manager_ref => "1"
      )
      expect(PG::Connection).to receive(:new).and_raise(PG::ConnectionBad)

      migrate
    end

    context "with an awx database connection" do
      let(:awx_conn) { instance_double(PG::Connection) }

      before do
        allow(PG::Connection).to receive(:new).with(a_hash_including(:dbname => "awx")).and_return(awx_conn)
      end

      it "removes unwanted data from options when the credential doesn't exist in the awx database" do
        auth = authentication.create!(
          :name        => "machine",
          :userid      => "machine",
          :type        => "ManageIQ::Providers::EmbeddedAnsible::AutomationManager::MachineCredential",
          :manager_ref => "3",
          :options     => {
            :ssh_key_data    => "$encrypted$",
            :ssh_key_unlock  => "",
            :become_method   => "sudo",
            :become_username => "machine",
            :become_password => "$encrypted$"
          }
        )

        stub_awx_cred_for_id(awx_conn, "3", [])

        migrate

        expect(auth.reload.options).to eq(:become_method => "sudo")
      end

      it "sets options to nil if there are none we care about" do
        auth = authentication.create!(
          :name        => "machine",
          :userid      => "machine",
          :type        => "ManageIQ::Providers::EmbeddedAnsible::AutomationManager::MachineCredential",
          :manager_ref => "3",
          :options     => {
            :ssh_key_data    => "$encrypted$",
            :become_username => "machine",
            :become_password => "$encrypted$"
          }
        )

        stub_awx_cred_for_id(awx_conn, "3", [])

        migrate

        expect(auth.reload.options).to be_nil
      end

      it "migrates options fields from the awx database" do
        auth = authentication.create!(
          :name        => "machine",
          :userid      => "machine",
          :type        => "ManageIQ::Providers::EmbeddedAnsible::AutomationManager::MachineCredential",
          :manager_ref => "3",
          :options     => {
            :ssh_key_data => "$encrypted$"
          }
        )

        awx_credential = {
          "inputs" => {
            "authorize"     => false,
            "become_method" => "sudo",
            "client"        => "someclient",
            "domain"        => "thebestdomain",
            "host"          => "host.example.com",
            "project"       => "manageiq",
            "subscription"  => "sub",
            "tenant"        => "atenant"
          }.to_json
        }

        stub_awx_cred_for_id(awx_conn, "3", [awx_credential])

        migrate
        auth.reload

        expected_options = {
          :authorize     => false,
          :become_method => "sudo",
          :client        => "someclient",
          :domain        => "thebestdomain",
          :host          => "host.example.com",
          :project       => "manageiq",
          :subscription  => "sub",
          :tenant        => "atenant"
        }

        expect(auth.options).to eq(expected_options)
      end

      it "migrates real data" do
        # load the initial set of authentication records
        auths = YAML.load_file(data_dir.join("vmdb_authentications.yaml"))
        auths.each { |auth| authentication.create!(auth["initial"]) }

        stub_awx_credentials(awx_conn)
        expect_credential_decrypts

        migrate

        expect_authentications_migrated
      end
    end
  end

  def stub_awx_cred_for_id(connection, id, data)
    expect(connection).to receive(:async_exec).with("SELECT inputs FROM main_credential WHERE id = $1::BIGINT", [id]).and_return(data)
  end

  def stub_awx_credentials(connection)
    credentials = YAML.load_file(data_dir.join("credential_attributes.yaml"))
    credentials.each do |cred|
      data = cred["attributes"].to_json
      stub_awx_cred_for_id(connection, cred["id"], [{"inputs" => data}])
    end
  end

  def expect_credential_decrypts
    stubs = YAML.load_file(data_dir.join("awesome_stubs.yaml"))
    stubs.each do |h|
      result = AwesomeSpawn::CommandResult.new("python3 standalone_decrypt.py", h[:output], "", 0)
      expect(AwesomeSpawn).to receive(:run).with(
        "python3",
        :params => array_including(/standalone_decrypt\.py/),
        :env    => h[:env]
      ).and_return(result)
    end
  end

  def expect_authentications_migrated
    authentications = YAML.load_file(data_dir.join("vmdb_authentications.yaml"))
    authentications.each do |auth|
      attrs = auth["migrated"]
      expected_attrs = encrypt_values(attrs)
      expect(authentication.find_by(:name => attrs["name"], :type => attrs["type"])).to have_attributes(expected_attrs)
    end
  end

  def encrypt_values(attrs)
    attrs.dup.tap do |h|
      %w[auth_key auth_key_password become_password password].each do |key|
        h[key] = ManageIQ::Password.encrypt(h[key].chomp) if h.key?(key)
      end
    end
  end
end
