class AddUidEmsToCloudNetworks < ActiveRecord::Migration[8.0]
  def change
    add_column :cloud_networks, :uid_ems, :string
    add_index :cloud_networks, :uid_ems
  end
end
