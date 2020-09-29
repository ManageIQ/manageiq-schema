class CreateStorageServices < ActiveRecord::Migration[5.2]
  def change
    create_table :storage_services do |t|
      t.string :name
      t.string :description
      t.bigint :version
      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
      t.string :ems_ref
      t.string :uid_ems
      t.string :type

      t.timestamps
    end
  end
end
