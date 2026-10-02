class AddUidEmsToCloudVolumes < ActiveRecord::Migration[8.0]
  def change
    add_column :cloud_volumes, :uid_ems, :string
    add_index :cloud_volumes, :uid_ems
  end
end
