class AddVlanInfoToGuestDevices < ActiveRecord::Migration[5.0]
  def change
    add_column :guest_devices, :vlan_key, :string
    add_column :guest_devices, :vlan_enabled, :boolean
  end
end
