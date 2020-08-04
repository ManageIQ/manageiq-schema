class CreateStorageResources < ActiveRecord::Migration[5.1]
  def change
    create_table :storage_resources do |t|
      t.string :name
      t.bigint :ems_id
      t.string :ems_ref
      t.string :uuid
      t.bigint :logical_free
      t.bigint :logical_total
      t.string :pool_name
      t.bigint :storage_system_id

      t.timestamps
    end
  end
end
