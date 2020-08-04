class CreateStorageResources < ActiveRecord::Migration[5.2]
  def change
    create_table :storage_resources do |t|
      t.string :name
      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
      t.string :ems_ref
      t.string :uuid
      t.bigint :logical_free
      t.bigint :logical_total
      t.references :physical_storage, :type => :bigint, :index => true
      t.timestamps
    end
  end
end
