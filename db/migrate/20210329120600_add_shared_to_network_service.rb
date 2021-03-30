class AddSharedToNetworkService < ActiveRecord::Migration[6.0]
  def change
    add_column :network_services, :shared, :boolean
  end
end
