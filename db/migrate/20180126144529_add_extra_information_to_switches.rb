class AddExtraInformationToSwitches < ActiveRecord::Migration[5.0]
  def change
    add_column :switches, :ems_id, :bigint
    add_column :switches, :type, :string
    add_column :switches, :health_state, :string
    add_column :switches, :power_state, :string
    add_column :switches, :product_name, :string
    add_column :switches, :part_number, :string
    add_column :switches, :serial_number, :string
    add_column :switches, :description, :string
    add_column :switches, :manufacturer, :string
  end
end
