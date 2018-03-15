class AddPeerMacAddressToGuestDevices < ActiveRecord::Migration[5.0]
  def change
    add_column :guest_devices, :peer_mac_address, :string
  end
end
