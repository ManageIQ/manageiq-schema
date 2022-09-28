class CreateStorageServiceCapabilities < ActiveRecord::Migration[6.1]
  def change
    create_table :storage_service_capabilities do |t|
      t.string :service_uuid
      t.string :capability_uuid
      t.string :ems_ref
      t.timestamps
    end
  end
end
