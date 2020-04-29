class AddDescriptionToCloudNetwork < ActiveRecord::Migration[5.1]
  def change
    add_column :cloud_networks, :description, :string
  end
end
