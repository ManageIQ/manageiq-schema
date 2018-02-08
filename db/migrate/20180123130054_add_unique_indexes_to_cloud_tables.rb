class AddUniqueIndexesToCloudTables < ActiveRecord::Migration[5.0]
  def change
    add_index :availability_zones,            %i(ems_id ems_ref), :unique => true
    add_index :cloud_services,                %i(ems_id ems_ref), :unique => true
    add_index :cloud_tenants,                 %i(ems_id ems_ref), :unique => true
    add_index :cloud_object_store_containers, %i(ems_id ems_ref), :unique => true
    add_index :cloud_object_store_objects,    %i(ems_id ems_ref), :unique => true
    add_index :cloud_networks,                %i(ems_id ems_ref), :unique => true
    add_index :cloud_volumes,                 %i(ems_id ems_ref), :unique => true
    add_index :cloud_volume_backups,          %i(ems_id ems_ref), :unique => true
    add_index :cloud_volume_snapshots,        %i(ems_id ems_ref), :unique => true
    add_index :cloud_resource_quotas,         %i(ems_id ems_ref), :unique => true
    add_index :flavors,                       %i(ems_id ems_ref), :unique => true
    add_index :resource_groups,               %i(ems_id ems_ref), :unique => true
    add_index :host_aggregates,               %i(ems_id ems_ref), :unique => true
    add_index :orchestration_templates,       %i(ems_id ems_ref), :unique => true
    add_index :orchestration_stacks,          %i(ems_id ems_ref), :unique => true
    add_index :vms,                           %i(ems_id ems_ref), :unique => true
  end
end
