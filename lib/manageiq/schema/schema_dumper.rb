module ManageIQ
  module Schema
    module SchemaDumper
      METRIC_ROLLUP_TABLE_REGEXP = /metrics?_.*\d\d$/.freeze

      def tables(stream)
        super
        miq_metric_views(stream)
        triggers(stream)
      end

      def miq_metric_views(stream)
        @connection.views.each do |view|
          stream.puts "  create_miq_metric_view #{view["name"].inspect}"
          stream.puts
        end
      end

      def triggers(stream)
        @connection.triggers.each do |(direction, table, name, body)|
          # Inverse of the case statement in add_trigger_hook
          direction_key = direction.downcase.gsub(/\s/, "")

          # Formats the SQL we get from the database to do that following:
          #
          # - Removes the "BEGIN" and "END;" stanzas
          # - Chomps the new lines from the beginning (keeps existing indent)
          # - Strips whitespace from the end (no need to worry about indent)
          # - Indents by four spaces
          #
          # For formatting, we want to ensure at least some bit of an indent,
          # regardless of how the SQL string was originally added.
          #
          formatted_body = body.gsub(/(BEGIN$|^END;$)/, "")
                               .reverse.chomp.reverse.rstrip
                               .indent(4)

          stream.puts "  add_trigger #{direction_key.inspect}, "       \
                                    "#{table.inspect}, "               \
                                    "#{name.inspect}, "                \
                                    "<<-SQL\n#{formatted_body}\n  SQL"
          stream.puts
        end
      end

      private

      def column_spec_for_primary_key(column)
        result = super
        result.delete(:default) if column.table_name.match?(METRIC_ROLLUP_TABLE_REGEXP)
        result
      end
    end
  end
end
