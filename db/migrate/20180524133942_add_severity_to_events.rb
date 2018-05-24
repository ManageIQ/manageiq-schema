class AddSeverityToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :event_streams, :severity, :string
  end
end
