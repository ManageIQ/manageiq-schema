class AddPhysicalInfraIndexesToEventStreams < ActiveRecord::Migration[8.0]
  def change
    add_index :event_streams, :physical_server_id
    add_index :event_streams, :physical_chassis_id
    add_index :event_streams, :physical_switch_id
    add_index :event_streams, :physical_storage_id
  end
end
