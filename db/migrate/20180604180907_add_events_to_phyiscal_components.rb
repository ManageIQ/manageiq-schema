class AddEventsToPhyiscalComponents < ActiveRecord::Migration[5.0]
  def change
    add_column :event_streams, :physical_component_id, :bigint
    remove_column :event_streams, :physical_server_id, :bigint
  end
end
