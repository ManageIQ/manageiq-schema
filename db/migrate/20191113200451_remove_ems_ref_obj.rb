class RemoveEmsRefObj < ActiveRecord::Migration[5.1]
  def change
    remove_column :ems_clusters, :ems_ref_obj, :string
    remove_column :ems_folders, :ems_ref_obj, :string
    remove_column :hosts, :ems_ref_obj, :string
    remove_column :resource_pools, :ems_ref_obj, :string
    remove_column :snapshots, :ems_ref_obj, :string
    remove_column :storages, :ems_ref_obj, :string
    remove_column :vms, :ems_ref_obj, :string
  end
end
