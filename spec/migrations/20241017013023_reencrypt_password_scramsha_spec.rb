require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe ReencryptPasswordScramsha do
  migration_context :up do
    it "Ensures that the user password is stored as scram-sha-256" do
      migrate

      username = ActiveRecord::Base.connection_db_config.configuration_hash[:username]

      users_and_passwords = ActiveRecord::Base.connection.execute <<-SQL
        SELECT rolname, rolpassword FROM pg_authid WHERE rolcanlogin;
      SQL

      record = users_and_passwords.to_a.detect { |i| i["rolname"] == username }

      expect(record["rolname"]).to eq(username)
      expect(record["rolpassword"]).to match(/^SCRAM-SHA-256.*/)
    end
  end
end
