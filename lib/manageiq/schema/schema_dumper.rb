module ManageIQ
  module Schema
    module SchemaDumper
      METRIC_ROLLUP_TABLE_REGEXP = /(?<METRIC_TYPE>metrics?_?.*)_(?<CHILD_TABLE_NUM>\d\d)$/.freeze

      def tables(stream)
        super
        miq_metric_table_sequences(stream)
        miq_metric_table_constraints(stream)
        miq_metric_views(stream)
        triggers(stream)
      end

      def table(table, stream)
        super
        add_id_column_comment(table, stream)
        track_miq_metric_table_inheritance(table)
      end

      def add_id_column_comment(table, stream)
        pk      = @connection.primary_key(table)
        pkcol   = @connection.columns(table).detect { |c| c.name == pk }
        comment = pkcol.try(:comment)

        return unless comment

        stream.puts "  change_column_comment #{remove_prefix_and_suffix(table).inspect}, #{pk.inspect}, #{comment.inspect}"
        stream.puts
      end

      def miq_metric_table_sequences(stream)
        inherited_metrics_tables.each do |(table, inherit_from)|
          stream.puts "  change_miq_metric_sequence #{table.inspect}, " \
                          "#{inherit_from.inspect}"
        end

        stream.puts
      end

      # Must be done after all of the table definitions since `metrics_01` is
      # dumped prior to `metrics_base`, etc.
      #
      def miq_metric_table_constraints(stream)
        inherited_metrics_tables.each do |(table, inherit_from)|
          child_table_num   = table.match(METRIC_ROLLUP_TABLE_REGEXP)[:CHILD_TABLE_NUM].to_i
          child_table       = remove_prefix_and_suffix(table).inspect
          primary_condition = if inherit_from.include?("rollup")
                                "capture_interval_name != ? AND EXTRACT(MONTH FROM timestamp) = ?"
                              else
                                "capture_interval_name = ? AND EXTRACT(HOUR FROM timestamp) = ?"
                              end
          conditions        = [primary_condition, "realtime", child_table_num]

          stream.puts "  add_miq_metric_table_inheritance #{child_table}, " \
                          "#{inherit_from.inspect}, "                       \
                          ":conditions => #{conditions.inspect}"
        end

        stream.puts
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
          #
          # For formatting, we want to ensure at least some bit of an indent,
          # regardless of how the SQL string was originally added.
          #
          formatted_body = body.gsub(/(BEGIN$|^END;$)/, "")
                               .reverse.chomp.reverse.rstrip

          stream.puts "  add_trigger #{direction_key.inspect}, "       \
                                    "#{table.inspect}, "               \
                                    "#{name.inspect}, "                \
                                    "<<-SQL\n#{formatted_body}\n  SQL"
          stream.puts
        end
      end

      private

      def track_miq_metric_table_inheritance(table)
        return unless table.match?(METRIC_ROLLUP_TABLE_REGEXP)
        return unless (inherit_from = determine_table_parent(table))

        inherited_metrics_tables << [table, inherit_from]
      end

      def inherited_metrics_tables
        @inherited_metrics_tables ||= []
      end

      def determine_table_parent(table_name)
        table = @connection.execute(<<-SQL)
          SELECT pg_class.relname AS parent_table
          FROM   pg_catalog.pg_inherits
          JOIN pg_class ON pg_class.oid = pg_inherits.inhparent
          WHERE inhrelid = '#{table_name}'::regclass
        SQL

        return if table.first.nil?

        table.first["parent_table"]
      end

      def column_spec_for_primary_key(column)
        result = super
        result.delete(:default) if column.table_name.match?(METRIC_ROLLUP_TABLE_REGEXP)
        result
      end
    end
  end
end
