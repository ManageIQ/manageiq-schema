class AddHostIdToSwitches < ActiveRecord::Migration[5.0]
  def change
    add_column :switches, :host_id, :bigint
  end
end
