class AddFirmwareTypeToHardware < ActiveRecord::Migration[5.0]
  def change
    add_column :hardwares, :firmware_type, :string
  end
end
