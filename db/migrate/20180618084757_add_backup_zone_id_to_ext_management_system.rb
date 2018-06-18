class AddBackupZoneIdToExtManagementSystem < ActiveRecord::Migration[5.0]
  def change
    add_column :ext_management_systems, :backup_zone_id, :integer, :after => :zone_id, :index => true
  end
end
