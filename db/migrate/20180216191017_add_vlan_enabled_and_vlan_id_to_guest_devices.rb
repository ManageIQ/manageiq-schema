class AddVlanEnabledAndVlanIdToGuestDevices < ActiveRecord::Migration[5.0]
  def change
    add_column :guest_devices, :vlan_enabled, :boolean
    add_column :guest_devices, :vlan_id, :string
  end
end
