require_migration

describe RemoveSpecialCharactersFromAnsibleRabbitmqPasswordTwo do
  let(:database_stub)       { migration_stub(:MiqDatabase) }
  let(:authentication_stub) { migration_stub(:Authentication) }
  let(:db_id)               { database_stub.first.id }
  let(:auth_attributes) do
    {
      :name          => "Ansible Rabbitmq Authentication",
      :authtype      => "ansible_rabbitmq_auth",
      :userid        => "tower",
      :type          => "AuthUseridPassword",
      :resource_id   => db_id,
      :resource_type => "MiqDatabase"
    }
  end

  before { database_stub.create! }

  migration_context :up do
    it "does nothing if the authentication record doesn't exist" do
      expect(rabbitmq_auths.count).to eq(0)
      migrate
      expect(rabbitmq_auths.count).to eq(0)
    end

    it "does not change the password if the existing one doesn't contain special characters" do
      authentication_stub.create!(auth_attributes.merge(:password => ManageIQ::Password.encrypt("password")))
      expect(ansible_rabbitmq_password).to eq("password")

      migrate

      expect(ansible_rabbitmq_password).to eq("password")
    end

    it "generates a new password when the existing one contains special characters" do
      authentication_stub.create!(auth_attributes.merge(:password => ManageIQ::Password.encrypt("pass_word")))
      expect(ansible_rabbitmq_password).to eq("pass_word")

      migrate

      expect(ansible_rabbitmq_password).to match(/^[a-zA-Z0-9]+$/)
    end
  end

  def rabbitmq_auths
    authentication_stub.where(auth_attributes)
  end

  def ansible_rabbitmq_password
    auths = rabbitmq_auths
    expect(auths.count).to eq(1)
    ManageIQ::Password.decrypt(auths.first.password)
  end
end
