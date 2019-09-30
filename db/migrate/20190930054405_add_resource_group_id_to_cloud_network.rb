class AddResourceGroupIdToCloudNetwork < ActiveRecord::Migration[5.1]
  def change
    add_reference :cloud_networks, :resource_group, :type => :bigint, :index => true
  end
end
