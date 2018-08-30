class AddPortStatusToPhysicalNetworkPorts < ActiveRecord::Migration[5.0]
  def change
    add_column :physical_network_ports, :port_status, :string
  end
end
