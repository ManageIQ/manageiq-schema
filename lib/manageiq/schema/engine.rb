module ManageIQ
  module Schema
    class Engine < ::Rails::Engine
      isolate_namespace ManageIQ::Schema

      # This auto-generated line is intentionally commented out to avoid
      #   autoload of helper classes when part of ManageIQ core.
      # config.autoload_paths << root.join('lib').to_s

      ActiveSupport.on_load(:active_record) do
        require_relative 'migrate_with_cleared_schema_cache'
        require_relative 'schema_statements'
        require_relative 'command_recorder'
        require_relative 'schema_dumper'

        ActiveRecord::Migration.prepend(MigrateWithClearedSchemaCache)

        ActiveRecord::ConnectionAdapters::AbstractAdapter.include(SchemaStatements)
        ActiveRecord::Migration::CommandRecorder.include(CommandRecorder)
        ActiveRecord::ConnectionAdapters::SchemaDumper.prepend(SchemaDumper)
      end

      initializer :append_migrations do |app|
        unless app.root.to_s.match root.to_s
          config.paths["db/migrate"].expanded.each do |expanded_path|
            app.config.paths["db/migrate"] << expanded_path
          end
          ActiveRecord::Migrator.migrations_paths = app.config.paths["db/migrate"]
          ActiveRecord::Tasks::DatabaseTasks.migrations_paths = app.config.paths["db/migrate"].to_a
        end
      end

      def self.vmdb_plugin?
        true
      end

      def self.plugin_name
        _('Schema')
      end
    end
  end
end
