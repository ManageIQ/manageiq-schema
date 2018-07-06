class AddLocLedNameAssetDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :asset_details, :location_led_ems_ref, :string
  end
end
