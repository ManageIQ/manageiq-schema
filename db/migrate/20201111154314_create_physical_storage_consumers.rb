class CreatePhysicalStorageConsumers < ActiveRecord::Migration[5.2]
  def change
    create_table :physical_storage_consumers do |t|
      t.string :name
      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
      t.string :ems_ref
      t.string :uid_ems
      t.references :physical_storage, :type => :bigint, :index => true

      t.timestamps
    end
  end
end
