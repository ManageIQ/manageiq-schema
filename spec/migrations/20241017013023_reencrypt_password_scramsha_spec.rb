require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe ReencryptPasswordScramsha do
  migration_context :up do
    it "Ensures that the user password is stored as scram-sha-256" do
      allow(ActiveRecord::Base.connection).to receive(:execute).and_call_original

      username = ActiveRecord::Base.connection_db_config.configuration_hash[:username]

      expect(ActiveRecord::Base.connection_db_config).to receive(:configuration_hash).exactly(10).times.and_call_original
      expect(ActiveRecord::Base.connection_db_config).to receive(:configuration_hash).and_wrap_original do |original_method, *args, &block|
        original_method.call(*args, &block).dup.tap { |i| i[:password] ||= "abc" }
      end
      expect(ActiveRecord::Base.connection).to receive(:execute).with(a_string_matching(/ALTER ROLE #{username} WITH PASSWORD \'SCRAM-SHA-256.*\'\;/))

      migrate
    end

    it "Handles connections with no password" do
      allow(ActiveRecord::Base.connection).to receive(:execute).and_call_original

      username = ActiveRecord::Base.connection_db_config.configuration_hash[:username]

      expect(ActiveRecord::Base.connection_db_config).to receive(:configuration_hash).exactly(10).times.and_call_original
      expect(ActiveRecord::Base.connection_db_config).to receive(:configuration_hash).and_wrap_original do |original_method, *args, &block|
        original_method.call(*args, &block).dup.tap { |i| i.delete(:password) }
      end
      expect(ActiveRecord::Base.connection).not_to receive(:execute).with(a_string_matching(/ALTER ROLE.*\'\;/))

      migrate
    end
  end
end
