class AddMaintenanceZoneIdToRegion < ActiveRecord::Migration[5.0]
  def change
    add_column :miq_regions, :maintenance_zone_id, :bigint, :index => true
  end
end
