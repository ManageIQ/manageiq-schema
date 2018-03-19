class AddProductDetailsColumnsToAssetDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :asset_details, :product_name,           :string
    add_column :asset_details, :manufacturer,           :string
    add_column :asset_details, :machine_type,           :string
    add_column :asset_details, :model,                  :string
    add_column :asset_details, :serial_number,          :string
    add_column :asset_details, :field_replaceable_unit, :string
  end
end
