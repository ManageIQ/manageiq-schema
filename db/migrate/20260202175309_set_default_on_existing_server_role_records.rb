class SetDefaultOnExistingServerRoleRecords < ActiveRecord::Migration[7.2]
  DEFAULT_ROLES = %w[automate database_operations event reporting scheduler
                     smartstate ems_operations ems_inventory ems_metrics_collector
                     ems_metrics_coordinator ems_metrics_processor notifier
                     user_interface remote_console web_services].freeze

  class ServerRole < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  def up
    # All new server_role records will default to false so we only need
    # to set specific ones to true here
    ServerRole.in_my_region.where(:name => DEFAULT_ROLES).update_all(:default => true)
  end
end
