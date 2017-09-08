class AddSerialNumberToHardware < ActiveRecord::Migration[5.0]
  def change
    add_column :hardwares, :serial_number, :string
  end
end
