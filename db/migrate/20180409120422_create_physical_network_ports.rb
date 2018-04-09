class CreatePhysicalNetworkPorts < ActiveRecord::Migration[5.0]
  def change
    create_table :physical_network_ports do |t|
      t.string  :ems_ref
      t.string  :uid_ems
      t.string  :type
      t.string  :port_name
      t.string  :port_type
      t.string  :peer_mac_address
      t.string  :vlan_key
      t.string  :mac_address
      t.integer :port_index
      t.boolean :vlan_enabled
      t.bigint  :guest_device_id
      t.bigint  :switch_id

      t.timestamps
    end
  end
end
