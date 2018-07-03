class AddChassisAndSwitchToEventStream < ActiveRecord::Migration[5.0]
  def change
    add_column :event_streams, :physical_chassis_id, :bigint
    add_column :event_streams, :physical_switch_id, :bigint
  end
end
