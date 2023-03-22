class DeleteForemanProvisioningRefreshSettings < ActiveRecord::Migration[6.1]
  class SettingsChange < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  def up
    say_with_time("Deleting Foreman ProvisioningManager Refresh SettingsChanges") do
      SettingsChange.in_my_region.where("key LIKE '/ems_refresh/foreman_provisioning/%'").delete_all
    end
  end
end
