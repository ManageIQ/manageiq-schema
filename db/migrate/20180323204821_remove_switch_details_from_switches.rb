class RemoveSwitchDetailsFromSwitches < ActiveRecord::Migration[5.0]
  def change
    remove_column :switches, :product_name,  :string
    remove_column :switches, :part_number,   :string
    remove_column :switches, :serial_number, :string
    remove_column :switches, :description,   :string
    remove_column :switches, :manufacturer,  :string
  end
end
