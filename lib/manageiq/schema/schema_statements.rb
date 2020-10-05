module ManageIQ
  module Schema
    module SchemaStatements
      def add_trigger(direction, table, name, body)
        add_trigger_function(name, body)
        add_trigger_hook(direction, name, table, name)
      end

      def drop_trigger(table, name)
        quoted_name  = quote_column_name(name)
        quoted_table = quote_table_name(table)

        execute("DROP TRIGGER IF EXISTS #{quoted_name} ON #{quoted_table};", 'Drop trigger')
        execute("DROP FUNCTION IF EXISTS #{quoted_name}();", 'Drop trigger function')
      end

      def drop_sequence(table)
        execute("DROP SEQUENCE #{table}_id_seq CASCADE", 'Drop sequence')
      end

      def create_miq_metric_view(name)
        execute("CREATE VIEW #{name} AS SELECT * FROM #{name}_base")
        execute("ALTER VIEW #{name} ALTER COLUMN id SET DEFAULT nextval('#{name}_base_id_seq')")
      end

      def drop_miq_metric_view(name)
        execute("DROP VIEW #{name}")
      end

      def add_miq_metric_table_inheritance(table, inherit_from, options = {})
        quoted_table      = quote_table_name(table)
        quoted_inherit    = quote_table_name(inherit_from)
        quoted_constraint = quote_column_name("#{table}_inheritance_check")
        conditions        = sanitize_sql_for_conditions(options[:conditions])

        execute("ALTER TABLE #{quoted_table} ADD CONSTRAINT #{quoted_constraint} CHECK (#{conditions})", 'Add inheritance check constraint')
        execute("ALTER TABLE #{quoted_table} INHERIT #{quoted_inherit}", 'Add table inheritance')
      end

      def drop_miq_metric_table_inheritance(table, inherit_from)
        quoted_table      = quote_table_name(table)
        quoted_inherit    = quote_table_name(inherit_from)
        quoted_constraint = quote_column_name("#{table}_inheritance_check")

        execute("ALTER TABLE #{quoted_table} DROP CONSTRAINT #{quoted_constraint}", 'Drop inheritance check constraint')
        execute("ALTER TABLE #{quoted_table} NO INHERIT #{quoted_inherit}", 'Drop table inheritance')
      end

      def change_miq_metric_sequence(table, inherit_from)
        drop_sequence(table)
        change_column_default(table, :id, -> { "nextval('#{inherit_from}_id_seq')" })
      end

      # Fetch the direction, table, name, and body for all of the MIQ INSERT
      # database triggers
      #
      def triggers
        select_rows(<<~TRIGGER_SQL.prepend("\n"))
          SELECT information_schema.triggers.action_timing AS direction,
                 pg_class.relname                          AS table,
                 pg_trigger.tgname                         AS name,
                 pg_proc.prosrc                            AS body
          FROM pg_trigger
          JOIN pg_class                    ON pg_trigger.tgrelid = pg_class.oid
          JOIN pg_proc                     ON pg_trigger.tgname  = pg_proc.proname
          JOIN information_schema.triggers ON pg_trigger.tgname  = information_schema.triggers.trigger_name
        TRIGGER_SQL
      end

      # Fetch the name, definition, kind, and namespace for the DB VIEWS in the
      # current DB
      #
      # Query taken and slightly modified from the scenic gem:
      #
      #   https://github.com/scenic-views/scenic/blob/048e0805/lib/scenic/adapters/postgres/views.rb#L25-L40
      #
      # TODO:  Just use scenic...
      #
      def views
        execute(<<~VIEW_SQL.prepend("\n"))
          SELECT c.relname             AS name,
                 pg_get_viewdef(c.oid) AS definition,
                 c.relkind             AS kind,
                 n.nspname             AS namespace
          FROM pg_class c
          LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
          WHERE c.relkind IN ('m', 'v')
            AND c.relname NOT IN (SELECT extname FROM pg_extension)
            AND n.nspname = ANY (current_schemas(false))
          ORDER BY c.oid
        VIEW_SQL
      end

      private

      def sanitize_sql_for_conditions(conditions)
        unless defined?(::DummyActiveRecordForMiqSchemaStatements)
          Object.const_set(:DummyActiveRecordForMiqSchemaStatements, Class.new(ActiveRecord::Base))
        end

        DummyActiveRecordForMiqSchemaStatements.send(:sanitize_sql_for_conditions, conditions)
      end

      def add_trigger_function(name, body)
        execute(<<-EOSQL, 'Create trigger function')
          CREATE OR REPLACE FUNCTION #{quote_table_name(name)}()
          RETURNS TRIGGER AS #{quote("BEGIN\n#{body}\nEND;\n")}
          LANGUAGE plpgsql;
        EOSQL
      end

      def add_trigger_hook(direction, name, table, function)
        safe_direction = case(direction.downcase)
                         when 'before'
                           'BEFORE'
                         when 'after'
                           'AFTER'
                         when 'insteadof'
                           'INSTEAD OF'
                         end

        execute(<<-EOSQL, 'Create trigger')
          CREATE TRIGGER #{quote_column_name(name)}
          #{safe_direction} INSERT ON #{quote_table_name(table)}
          FOR EACH ROW EXECUTE PROCEDURE #{quote_table_name(function)}();
        EOSQL
      end
    end
  end
end
