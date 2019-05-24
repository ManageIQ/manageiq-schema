class CreateFirmwareBinaryFirmwareTargets < ActiveRecord::Migration[5.0]
  def change
    create_table :firmware_binaries_firmware_targets do |t|
      t.references :firmware_binary, :type => :bigint, :index => false
      t.references :firmware_target, :type => :bigint, :index => false

      t.index %i[firmware_binary_id firmware_target_id], :unique => true, :name => :index_firmware_binaries_firmware_targets
    end
  end
end
