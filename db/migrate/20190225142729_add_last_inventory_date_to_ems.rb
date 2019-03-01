class AddLastInventoryDateToEms < ActiveRecord::Migration[5.0]
  def change
    add_column :ext_management_systems, :last_inventory_date, :datetime
  end
end
