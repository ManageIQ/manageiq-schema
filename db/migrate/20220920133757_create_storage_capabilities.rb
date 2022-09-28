class CreateStorageCapabilities < ActiveRecord::Migration[6.1]
  def change
    create_table :storage_capabilities do |t|
      t.string :name
      t.string :ems_ref
      t.timestamps
    end
  end
end