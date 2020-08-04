class CreateServiceResourceAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :service_resource_attachments do |t|
      t.bigint :storage_service_id
      t.bigint :storage_resource_id
      t.boolean :compliant
      t.bigint :ems_id
      t.string :ems_ref

      t.timestamps
    end
  end
end
