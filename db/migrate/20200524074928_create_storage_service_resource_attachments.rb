class CreateStorageServiceResourceAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :storage_service_resource_attachments do |t|
      t.references :storage_service, :type => :bigint, :index => {:name => "index_storage_svc_resource_attachments_on_storage_service_id"}
      t.references :storage_resource, :type => :bigint, :index => {:name => "index_storage_svc_resource_attachments_on_storage_resource_id"}
      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
      t.string :ems_ref

      t.timestamps
    end
  end
end
