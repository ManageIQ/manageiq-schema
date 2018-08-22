class AddExtraInformationToSwitches < ActiveRecord::Migration[5.0]
  def change
    add_column :switches, :ems_id, :bigint
    add_column :switches, :type, :string
    add_column :switches, :health_state, :string
    add_column :switches, :power_state, :string
  end
end
