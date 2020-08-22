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

      private

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
