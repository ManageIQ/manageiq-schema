require_migration

describe CollapsedInitialMigration do
  migration_context :up do
    let(:connection) { ActiveRecord::Base.connection }

    it "will fail on a non-empty database" do
      connection.execute("INSERT INTO schema_migrations VALUES ('20180123123456'), ('20190123123456')")

      expect { migrate }.to raise_error(StandardError, /cannot be migrated/)
    end
  end
end
