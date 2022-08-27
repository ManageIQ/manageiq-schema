class AddFixedToEventStreams < ActiveRecord::Migration[6.0]
  def change
    add_column :event_streams, :fixed, :string
  end
end
