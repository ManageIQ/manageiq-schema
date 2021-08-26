module Spec
  module Support
    module MigrationIdRegionsHelper
      def anonymous_class_with_id_regions
        ActiveRecord::IdRegions::Migration.anonymous_class_with_id_regions
      end

      def id_in_current_region(id)
        anonymous_class_with_id_regions.id_in_region(id, anonymous_class_with_id_regions.my_region_number)
      end
    end
  end
end
