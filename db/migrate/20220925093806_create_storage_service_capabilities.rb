class CreateStorageServiceCapabilities < ActiveRecord::Migration[6.1]
  def change
    create_table :storage_service_capabilities do |t|
      t.string :service_uuid
      t.bigint :capability_id
      t.timestamps
    end
  end
end
