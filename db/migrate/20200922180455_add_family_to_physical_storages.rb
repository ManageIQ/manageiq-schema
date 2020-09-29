class AddFamilyToPhysicalStorages < ActiveRecord::Migration[5.2]
  def change
    add_reference :physical_storages, :physical_storage_family, :type => :bigint, :index => true
  end
end
