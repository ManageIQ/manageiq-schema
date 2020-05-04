require_migration
require 'json'
require 'yaml'

describe MoveAwxCredentialsToAuthentications do
  let(:script_path) do
    File.expand_path(Pathname.new(__dir__).join("..", "..", "db", "migrate", "data", File.basename(__FILE__, "_spec.rb"), "standalone_decrypt.py"))
  end

  let(:data_dir) { Pathname.new(__dir__).join("data", File.basename(__FILE__, ".rb")) }

  let(:authentication) { migration_stub(:Authentication) }
  let(:miq_database)   { migration_stub(:MiqDatabase) }

  let(:awx_conn)        { instance_double(PG::Connection) }
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

  # Since the @secret_key is memoized in the class of AnsibleDecrypt, between
  # specs this won't get refreshed with any changes if they were provided.
  #
  # Previously this wasn't a problem since we always used the same key in the
  # specs... but times are changing!
  after do
    described_class::AnsibleDecrypt.instance_variable_set(:@secret_key, nil)
  end

  migration_context :up do
    describe "AnsibleDecrypt" do
      let(:cases) do
        [
          {
            :value => "test",
            :encrypted => "$encrypted$UTF8$AESCBC$Z0FBQUFBQmRFN1hsODNWMUN6cTktanZfZm5GMG5tbXNYZXBXQzBBVWVaWXBkZUx1bUFPVXhxZUo4cHcxdjlFeWZqNi1EX3FiZTRGa2dCUTlsMHE3UnBEeG52Y1JSa2V4amc9PQ=="
          },
          {
            :value => "password",
            :encrypted => "$encrypted$UTF8$AESCBC$Z0FBQUFBQmRFN1hsMTgycWViNl9PajJnSk54ME93bklRZXgwRXNjWjAyMDB5dE5ESGRlSEhoR3pJM2Q4Z1R4OXo4N2JmZXRlT19FaENtWHViRXBRTDFKa1A5c09wVHAzbGc9PQ=="
          },
          {
            :value => "ca$hcOw",
            :encrypted => "$encrypted$UTF8$AESCBC$Z0FBQUFBQmRFN1hsQ3BkXzFfVDgweUotVlhDcmpSRWlYV1BIU0RTdTNSR1BWanRYRVhWV0tMVzRFcTNSU0tPT0hmRUNIT0lXZ09hUk1IY2x6Sm1SYW13N1RDYks2TUd5MWc9PQ=="
          },
          {
            :value => "Tw45!&zQ",
            :encrypted => "$encrypted$UTF8$AESCBC$Z0FBQUFBQmRFN1hsOXo0MDlKenRtM0RjUkx5blo2TlFlOVBqcE50c1N4Z2Zka3daSzgyVVJNVUlGWi04cU5TTjBZVElGbkw4SHNSb1JoTDVlMS04SUVSaG5LbXIwRmYtaUE9PQ=="
          },
          {
            :value => "`~!@\#$%^&*()_+-=[]{}\\|;:\"'<>,./?",
            :encrypted => "$encrypted$UTF8$AESCBC$Z0FBQUFBQmRFN1hsOXhvRk9GQ21SYWVHbmdESXl3aHk0bUxfaUpBRks3U0k3ZWx4U3hPcGxUd29nSUIzTlhoRmNxWVpia2lwN1U4RF9ubVpFUDZPeldGbGN2blZMeXM2SHNQWFZEWnRjdEtyRTdPVVVBSTFVaWRwcGRGX0hZNmtqNVU1eEthbXlFQlo="
          },
          {
            :value => "abc\t\n\vzabc",
            :encrypted => "$encrypted$UTF8$AESCBC$Z0FBQUFBQmRFN1hsU3A0OXF5d1FrMlViU2N0ZDNIVEh3OVF5THdaMFpaTlFhMERSaDlnVk5EcUtZVnZ0TlhielJ1cUlfTVRDY0pPVHNONkdjcGN4bTFZRXo2bFV2WHk4aXc9PQ=="
          },
          {
            :value => "äèíôúñæþß",
            :encrypted => "$encrypted$UTF8$AESCBC$Z0FBQUFBQmRFN1hsVHN2dy1wY2RKQ21fWFlWcGh4UmRac1VUVkE0X2dLT2pZYkdmaW1tN0JKTU8xSXV0eW9qUjdsb2ZvVWFVczZTVGVzWWhFRnA3bTZCbzBBNzBnSnpwUG5jZHBNTGEwYUQ0RGRXRkwyaGd0ZUk9"
          },
          {
            :value => "\343\201\223\343\201\253\343\201\241\343\202\217",
            :encrypted => "$encrypted$UTF8$AESCBC$Z0FBQUFBQmRFN1htSGw5bEFsdXQ5LVE3anFpdm55d0ktYmpSWDNwV0ZwMWNWdmhzckFrdV9Obk02bzQwTDJKRVlwaDgwdDZMYU4tR2p6OVJ0T3UtX1JCQ3lqbjY0QmNLb2c9PQ=="
          },
          {
            :value => "\345\257\206\347\240\201",
            :encrypted => "$encrypted$UTF8$AESCBC$Z0FBQUFBQmRFN1htSGdGazNOWkEwMzl3VlJQSlB5bHJIc3FSRWN1Z0Y0OFJJemRBVndLZGpjRzZ2aHZhMW5STkljbmlPa1h6cWQyVlkzRjd3SEZkS0JsRDZWNFNJNFpWaFE9PQ=="
          },
          {
            :value => "şŞ",
            :encrypted => "$encrypted$UTF8$AESCBC$Z0FBQUFBQmRFN1htOUdENV9Eendob0s3NVRSRjN1Yjd4T25JZmthbEYtVWtSbEdLV0pOcjhuTlluRjBOeUFXelV2OUhtWFFCVzE2MzV6ZE1DZmVJRFE1YWJSVDlOUndfcVE9PQ=="
          }
        ]
      end

      it "decrypts special cases successfully" do
        cases.each do |c|
          decrypted = described_class::AnsibleDecrypt.decrypt("password", c[:encrypted], "1")
          expect(decrypted).to eq(c[:value])
        end
      end
    end

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

      it "migrates credentials with nil options" do
        auth = authentication.create!(
          :name        => "machine",
          :userid      => "machine",
          :type        => "ManageIQ::Providers::EmbeddedAnsible::AutomationManager::MachineCredential",
          :manager_ref => "3"
        )

        stub_awx_cred_for_id(awx_conn, "3", [{"inputs" => {"password" => "qwerty"}.to_json}])

        migrate

        auth.reload

        expect(auth.options).to be_nil
        expect(ManageIQ::Password.decrypt(auth.password)).to eq("qwerty")
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

      it "sets the manager ref to the authentication id" do
        auth = authentication.create!(
          :name        => "machine",
          :userid      => "machine",
          :type        => "ManageIQ::Providers::EmbeddedAnsible::AutomationManager::MachineCredential"
        ).tap { |a| a.update!(:manager_ref => (a.id + 10).to_s) }

        stub_awx_cred_for_id(awx_conn, (auth.id + 10).to_s, [{"inputs" => {}.to_json}])

        migrate

        expect(auth.reload.manager_ref).to eq(auth.id.to_s)
      end

      it "migrates real data" do
        # load the initial set of authentication records
        auths = YAML.load_file(data_dir.join("vmdb_authentications.yaml"))
        auths.each { |auth| authentication.create!(auth["initial"]) }

        stub_awx_credentials(awx_conn)

        migrate

        expect_authentications_migrated
      end

      context "with a 'bogus' secret key (DB restore use case)" do
        let(:secret_key) { "invalid" }

        before do
          # load the initial set of authentication records
          auths = YAML.load_file(data_dir.join("vmdb_authentications.yaml"))
          auths.each { |auth| authentication.create!(auth["initial"]) }

          stub_awx_credentials(awx_conn, true)
        end

        it "fails to migrate real data and fails with an error" do
          expect { migrate }.to raise_error(StandardError, /#{described_class::Fernet256::InvalidToken.to_s}/)
        end

        context "with $HARDCODE_ANSIBLE_PASSWORD set 'bogus'" do
          around do |example|
            begin
              old_env = ENV.delete("HARDCODE_ANSIBLE_PASSWORD")
              ENV["HARDCODE_ANSIBLE_PASSWORD"] = 'bogus'

              example.run
            ensure
              ENV["HARDCODE_ANSIBLE_PASSWORD"] = old_env
            end
          end

          it "sets a default if the value fails to decrypt" do
            migrate
            expect_authentications_migrated('bogus')
          end
        end
      end
    end
  end

  def stub_awx_cred_for_id(connection, id, data, rspec_allow = false)
    query = ["SELECT inputs FROM main_credential WHERE id = $1::BIGINT", [id]]

    if rspec_allow
      allow(connection)
    else
      expect(connection)
    end.to receive(:async_exec).with(*query).and_return(data)
  end

  def stub_awx_credentials(connection, rspec_allow = false)
    credentials = YAML.load_file(data_dir.join("credential_attributes.yaml"))
    credentials.each do |cred|
      data = cred["attributes"].to_json
      stub_awx_cred_for_id(connection, cred["id"], [{"inputs" => data}], rspec_allow)
    end
  end

  def expect_authentications_migrated(using_hardcoded_secret = nil)
    authentications = YAML.load_file(data_dir.join("vmdb_authentications.yaml"))
    authentications.each do |auth|
      attrs = auth["migrated"]
      expected_attrs = encrypt_values(attrs, using_hardcoded_secret)
      expect(authentication.find_by(:name => attrs["name"], :type => attrs["type"])).to have_attributes(expected_attrs)
    end
  end

  def encrypt_values(attrs, using_hardcoded_secret = nil)
    attrs.dup.tap do |h|
      %w[auth_key auth_key_password become_password password].each do |key|
        if h.key?(key)
          value_to_encrypt = using_hardcoded_secret || h[key].chomp
          h[key] = ManageIQ::Password.encrypt(value_to_encrypt)
        end
      end
    end
  end
end
