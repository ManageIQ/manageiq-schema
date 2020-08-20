module ManageIQ
  module Schema
    module SchemaDumper
      METRIC_ROLLUP_TABLE_REGEXP = /metrics?_.*\d\d$/.freeze

      private

      def column_spec_for_primary_key(column)
        result = super
        result.delete(:default) if column.table_name.match?(METRIC_ROLLUP_TABLE_REGEXP)
        result
      end
    end
  end
end
