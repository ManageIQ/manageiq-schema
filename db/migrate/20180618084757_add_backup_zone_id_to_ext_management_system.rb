class AddBackupZoneIdToExtManagementSystem < ActiveRecord::Migration[5.0]
  def change
    add_reference :ext_management_systems, :backup_zone, :type => :bigint, :index => true, :after => :zone_id
  end
end
