class AddTotalSpaceToPhysicalStorages < ActiveRecord::Migration[5.0]
  def change
    add_column :physical_storages, :total_space, :bigint
  end
end
