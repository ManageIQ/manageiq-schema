class AddEventIdToEventStreams < ActiveRecord::Migration[5.0]
  def change
    add_column :event_streams, :ems_ref, :string
  end
end
