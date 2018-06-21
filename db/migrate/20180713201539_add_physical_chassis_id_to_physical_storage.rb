class AddPhysicalChassisIdToPhysicalStorage < ActiveRecord::Migration[5.0]
  def change
    add_column :physical_storages, :physical_chassis_id, :bigint
  end
end
