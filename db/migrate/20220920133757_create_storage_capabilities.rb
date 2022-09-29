class CreateStorageCapabilities < ActiveRecord::Migration[6.1]
  def change
    create_table :storage_capabilities do |t|
      t.string :name
      t.string :ems_ref
      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
      t.timestamps
    end
  end
end