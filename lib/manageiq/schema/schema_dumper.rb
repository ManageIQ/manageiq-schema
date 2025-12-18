module ManageIQ
  module Schema
    module SchemaDumper
      METRIC_ROLLUP_TABLE_REGEXP = /(?<METRIC_TYPE>metrics?_?.*)_(?<CHILD_TABLE_NUM>\d\d)$/.freeze

      def tables(stream)
        ignoring_tables(inherited_tables, stream) { super }
        ignoring_tables(base_tables, stream) { super }

        miq_metric_table_sequences(stream)
        miq_metric_table_inheritances(stream)
        miq_metric_views(stream)
        triggers(stream)
      end

      # We need to ignore tables that are inherited from the parent table because the default
      # behavior for schema dumping the tables is to dump them sorted:
      # https://github.com/rails/rails/blob/624fe3cdb9ab774ff598af29f408425178da6677/activerecord/lib/active_record/schema_dumper.rb#L137
      # This leads to an incorrect sequence in schema.rb:
      # a) create_table "metric_rollups_01", id: :bigint, options: "INHERITS (metric_rollups_base)"...
      # b) create_table "metric_rollups_base", force: :cascade do |t|
      # You're not able to schema load from the dumped schema because metric_rollups_base is
      # not created at the time a) references it when creating metric_rollups_01.
      #
      # We mention this as a long known problem, see the comment from
      # miq_metric_table_inheritances below:
      #
      # "Must be done after all of the table definitions since `metrics_01` is
      # dumped prior to `metrics_base`, etc."
      #
      # We could resolve this by renaming the base table so it came before the subtables alphabetically or
      # if rails's schema_dumper's tables method handled inheritance and partitioning by ensuring to dump the
      # base table before the subtables.
      #
      # Instead, we resolve this by doing the following:
      # * Use the ignore_tables feature in rails to ignore the subtables in the tables method
      #   to dump the base tables and finally, we ignore the base tables and dump the subtables.
      # * Note: we're manually setting it via ivar because the cattr_accessor needs to be set before
      #   the schema dumper is initialized:
      #   https://github.com/rails/rails/blob/624fe3cdb9ab774ff598af29f408425178da6677/activerecord/lib/active_record/schema_dumper.rb#L78-L81
      def ignoring_tables(tables, stream)
        before = @ignore_tables.dup
        @ignore_tables |= tables

        yield

        stream.puts
        @ignore_tables = before
      end

      def table(table, stream)
        super
        add_id_column_comment(table, stream)
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
        inherited_tables.each do |table|
          ActiveRecord::Base.connection.inherited_table_names(table).each do |inherit_from|
            stream.puts "  change_miq_metric_sequence #{table.inspect}, " \
                        "#{inherit_from.inspect}"
          end
        end

        stream.puts
      end

      # Must be done after all of the table definitions since `metrics_01` is
      # dumped prior to `metrics_base`, etc.
      #
      # TODO: Remove this once we upgrade to Rails 8.0 and drop support for 7.2!
      def miq_metric_table_inheritances(stream)
        # FYI, Rails 8.0 added this in https://github.com/rails/rails/pull/50475
        return if Rails.version >= "8.0"

        inherited_tables.each do |table|
          child_table = remove_prefix_and_suffix(table).inspect
          ActiveRecord::Base.connection.inherited_table_names(table).each do |inherit_from|
            stream.puts "  add_miq_metric_table_inheritance #{child_table}, " \
                        "#{inherit_from.inspect} "
          end
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

          # Formats the SQL we get from the database to do the following:
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

      def base_inherited_tables_partition
        @base_inherited_tables_partition ||= ActiveRecord::Base.connection.tables.sort.partition do |t|
          parent = ActiveRecord::Base.connection.inherited_table_names(t)
          parent.blank?
        end
      end

      def base_tables
        base_inherited_tables_partition.first
      end

      def inherited_tables
        base_inherited_tables_partition.last
      end

      def column_spec_for_primary_key(column)
        result = super
        result.delete(:default) if table_name.match?(METRIC_ROLLUP_TABLE_REGEXP)
        result
      end
    end
  end
end
