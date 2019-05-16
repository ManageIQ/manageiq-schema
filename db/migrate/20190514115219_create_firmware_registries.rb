class CreateFirmwareRegistries < ActiveRecord::Migration[5.0]
  def change
    create_table :firmware_registries do |t|
      t.string   :name
      t.datetime :last_refresh_on
      t.text     :last_refresh_error
      t.string   :type
      t.timestamps
    end
  end
end
