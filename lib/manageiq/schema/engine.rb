module ManageIQ
  module Schema
    class Engine < ::Rails::Engine
      isolate_namespace ManageIQ::Schema

      ActiveSupport.on_load(:active_record) do
        require_relative 'migrate_with_cleared_schema_cache'
        ActiveRecord::Migration.prepend(MigrateWithClearedSchemaCache)
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
