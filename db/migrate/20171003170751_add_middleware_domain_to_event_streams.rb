class AddMiddlewareDomainToEventStreams < ActiveRecord::Migration[5.0]
  def change
    add_column :event_streams, :middleware_domain_id, :bigint
    add_column :event_streams, :middleware_domain_name, :string
  end
end
