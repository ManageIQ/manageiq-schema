class AddSpeedToGuestDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :guest_devices, :speed, :bigint
  end
end
