class AddOptionsAndStatusToServiceResource < ActiveRecord::Migration[5.0]
  def change
    add_column :service_resources, :options, :jsonb, :default => {}
    add_column :service_resources, :status,  :string
  end
end
