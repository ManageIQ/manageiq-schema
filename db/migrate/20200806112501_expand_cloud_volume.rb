#  https://apidock.com/rails/ActiveRecord/ConnectionAdapters/SchemaStatements/

class ExpandCloudVolume < ActiveRecord::Migration[5.1]

  def change
    add_column :cloud_volumes, :storage_resource_id, :bigint
    add_column :cloud_volumes, :storage_service_id, :bigint
    add_column :cloud_volumes, :compliant, :boolean
    add_column :cloud_volumes, :volume_source, :string
  end
end
