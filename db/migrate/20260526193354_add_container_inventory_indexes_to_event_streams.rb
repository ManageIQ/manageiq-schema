class AddContainerInventoryIndexesToEventStreams < ActiveRecord::Migration[8.0]
  def change
    add_index :event_streams, :container_group_id
    add_index :event_streams, :container_id
    add_index :event_streams, :container_node_id
    add_index :event_streams, :container_replicator_id
  end
end
