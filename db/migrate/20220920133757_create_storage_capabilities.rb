class CreateStorageCapabilities < ActiveRecord::Migration[6.1]
  def change
    create_table :storage_capabilities do |t|
      t.string :uuid
      t.string :name
      t.timestamps
    end
  end
end