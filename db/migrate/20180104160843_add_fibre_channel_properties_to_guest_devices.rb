class AddFibreChannelPropertiesToGuestDevices < ActiveRecord::Migration[5.0]
  def change
    add_column :guest_devices, :storage_node_wwn,  :string
    add_column :guest_devices, :storage_port_type, :string
    add_column :guest_devices, :storage_port_wwn,  :string
    add_column :guest_devices, :storage_speed,     :int
  end
end
