class AddHiddenToClusters < ActiveRecord::Migration[5.2]
  def change
    add_column :ems_clusters, :hidden, :boolean
  end
end
