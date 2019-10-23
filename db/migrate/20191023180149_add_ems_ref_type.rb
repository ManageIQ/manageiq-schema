class AddEmsRefType < ActiveRecord::Migration[5.1]
  def change
    add_column :ems_clusters, :ems_ref_type, :string
    add_column :ems_folders, :ems_ref_type, :string
    add_column :hosts, :ems_ref_type, :string
    add_column :resource_pools, :ems_ref_type, :string
    add_column :snapshots, :ems_ref_type, :string
    add_column :storages, :ems_ref_type, :string
    add_column :vms, :ems_ref_type, :string
  end
end
