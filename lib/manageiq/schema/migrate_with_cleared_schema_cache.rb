module ManageIQ
  module Schema
    module MigrateWithClearedSchemaCache
      def migrate(*args)
        clearing_caches do
          super
        end
      end

      private

      def clear_caches
        ActiveRecord::Base.connection.schema_cache.clear!
      end

      def clearing_caches
        clear_caches
        yield
      end
    end
  end
end
