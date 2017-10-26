class AddMtuToSwitches < ActiveRecord::Migration[5.0]
  def change
    add_column :switches, :mtu, :integer
  end
end
