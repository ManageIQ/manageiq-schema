class AddRawPowerStateToHosts < ActiveRecord::Migration[8.0]
  def change
    add_column :hosts, :raw_power_state, :string
  end
end
