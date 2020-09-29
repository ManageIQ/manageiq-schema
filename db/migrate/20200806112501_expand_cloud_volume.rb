class ExpandCloudVolume < ActiveRecord::Migration[5.2]
  def change
    add_reference :cloud_volumes, :storage_resource, :type => :bigint, :index => true
    add_reference :cloud_volumes, :storage_service, :type => :bigint, :index => true
  end
end
