class AddResourceGroupIdToNetworkPort < ActiveRecord::Migration[5.1]
  def change
    add_reference :network_ports, :resource_group, :type => :bigint, :index => true
  end
end
