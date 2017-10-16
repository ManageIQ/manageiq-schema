class AddUserToEventStream < ActiveRecord::Migration[5.0]
  def change
    add_column :event_streams, :user_id, :bigint
    add_column :event_streams, :group_id, :bigint
    add_column :event_streams, :tenant_id, :bigint
  end
end
