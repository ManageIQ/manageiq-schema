class AddPartNumberToAssetDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :asset_details, :part_number, :string
  end
end
