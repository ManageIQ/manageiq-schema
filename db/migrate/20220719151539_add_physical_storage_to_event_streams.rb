class AddPhysicalStorageToEventStreams < ActiveRecord::Migration[6.0]
  def change
    add_column :event_streams, :physical_storage_id, :bigint
    add_column :event_streams, :physical_storage_name, :string
  end
end
