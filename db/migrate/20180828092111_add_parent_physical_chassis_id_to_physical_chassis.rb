class AddParentPhysicalChassisIdToPhysicalChassis < ActiveRecord::Migration[5.0]
  def change
    add_column :physical_chassis, :parent_physical_chassis_id, :bigint
  end
end
