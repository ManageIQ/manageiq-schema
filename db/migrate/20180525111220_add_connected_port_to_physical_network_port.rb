class AddConnectedPortToPhysicalNetworkPort < ActiveRecord::Migration[5.0]
  def change
    add_column :physical_network_ports, :connected_port_uid, :string
  end
end
