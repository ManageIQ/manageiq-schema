class CreateStorageSystemTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :storage_system_types do |t|
      t.string :name
      t.string :version
      t.bigint :ems_id
      t.string :ems_ref

      t.timestamps
    end
  end
end
