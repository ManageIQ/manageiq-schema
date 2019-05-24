class CreateFirmwareTargets < ActiveRecord::Migration[5.0]
  def change
    create_table :firmware_targets do |t|
      t.string :manufacturer
      t.string :model
      t.timestamps
    end
  end
end
