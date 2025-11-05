class DropLogCollectionConfiguration < ActiveRecord::Migration[7.2]
  class MiqProductFeature < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  class MiqRolesFeature < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  class SettingsChange < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  FEATURE_NAMES = %w[
    collect_current_logs
    collect_logs
    log_depot_edit
    zone_collect_current_logs
    zone_collect_logs
    zone_log_depot_edit
  ].freeze

  def up
    say_with_time("Removing log collection product features") do
      MiqProductFeature.in_my_region.where(:identifier => FEATURE_NAMES).each do |feature|
        MiqRolesFeature.where(:miq_product_feature_id => feature.id).delete_all
        feature.delete
      end
    end

    say_with_time("Removing log collection settings") do
      SettingsChange.in_my_region.where("key LIKE ?", "/log/collection%").delete_all
    end
  end
end
