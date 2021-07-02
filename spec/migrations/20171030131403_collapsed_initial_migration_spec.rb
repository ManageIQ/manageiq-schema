require_migration

describe CollapsedInitialMigration do
  let(:connection) { ActiveRecord::Base.connection }

  migration_context :down do
    it "database should be empty" do
      migrate

      tables = connection.select_values("SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename NOT IN ('schema_migrations', 'ar_internal_metadata')")
      expect(tables).to be_empty

      indexes = connection.select_values("SELECT indexname FROM pg_indexes WHERE schemaname = 'public' AND indexname NOT IN ('schema_migrations_pkey', 'ar_internal_metadata_pkey')")
      expect(indexes).to be_empty

      sequences = connection.select_values("SELECT sequencename FROM pg_sequences WHERE schemaname = 'public'")
      expect(sequences).to be_empty

      trigger_funcs = connection.select_values("SELECT proname FROM pg_proc INNER JOIN pg_namespace ON (pronamespace = pg_namespace.oid) WHERE nspname = 'public'")
      expect(trigger_funcs).to be_empty

      views = connection.select_values("SELECT viewname FROM pg_views WHERE schemaname = 'public'")
      expect(views).to be_empty

      mat_views = connection.select_values("SELECT matviewname FROM pg_matviews WHERE schemaname = 'public'")
      expect(mat_views).to be_empty
    end
  end
end
