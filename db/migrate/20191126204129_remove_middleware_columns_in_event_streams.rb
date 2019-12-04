class RemoveMiddlewareColumnsInEventStreams < ActiveRecord::Migration[5.0]
  def up
    remove_column :event_streams, :middleware_server_id
    remove_column :event_streams, :middleware_server_name
    remove_column :event_streams, :middleware_deployment_id
    remove_column :event_streams, :middleware_deployment_name
    remove_column :event_streams, :middleware_domain_id
    remove_column :event_streams, :middleware_domain_name
  end

  def down
    add_column :event_streams, :middleware_server_id, :bigint
    add_column :event_streams, :middleware_server_name, :string
    add_column :event_streams, :middleware_deployment_id, :bigint
    add_column :event_streams, :middleware_deployment_name, :string
    add_column :event_streams, :middleware_domain_id, :bigint
    add_column :event_streams, :middleware_domain_name, :string
  end
end
