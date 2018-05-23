class AddTypeAndKeyToGuestDevices < ActiveRecord::Migration[5.0]
  def change
    add_column :guest_devices, :type, :string
    add_column :guest_devices, :key,  :integer
  end
end
