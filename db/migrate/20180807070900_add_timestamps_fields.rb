class AddTimestampsFields < ActiveRecord::Migration[5.0]
  def change
    add_column :availability_zones,            :resource_timestamp, :datetime
    add_column :cloud_services,                :resource_timestamp, :datetime
    add_column :cloud_tenants,                 :resource_timestamp, :datetime
    add_column :cloud_object_store_containers, :resource_timestamp, :datetime
    add_column :cloud_object_store_objects,    :resource_timestamp, :datetime
    add_column :cloud_networks,                :resource_timestamp, :datetime
    add_column :cloud_volumes,                 :resource_timestamp, :datetime
    add_column :cloud_volume_backups,          :resource_timestamp, :datetime
    add_column :cloud_volume_snapshots,        :resource_timestamp, :datetime
    add_column :cloud_resource_quotas,         :resource_timestamp, :datetime
    add_column :flavors,                       :resource_timestamp, :datetime
    add_column :resource_groups,               :resource_timestamp, :datetime
    add_column :host_aggregates,               :resource_timestamp, :datetime
    add_column :orchestration_templates,       :resource_timestamp, :datetime
    add_column :orchestration_stacks,          :resource_timestamp, :datetime
    add_column :vms,                           :resource_timestamp, :datetime
    add_column :hardwares,                     :resource_timestamp, :datetime
    add_column :disks,                         :resource_timestamp, :datetime

    add_column :availability_zones,            :resource_timestamps, :jsonb, default: {}
    add_column :cloud_services,                :resource_timestamps, :jsonb, default: {}
    add_column :cloud_tenants,                 :resource_timestamps, :jsonb, default: {}
    add_column :cloud_object_store_containers, :resource_timestamps, :jsonb, default: {}
    add_column :cloud_object_store_objects,    :resource_timestamps, :jsonb, default: {}
    add_column :cloud_networks,                :resource_timestamps, :jsonb, default: {}
    add_column :cloud_volumes,                 :resource_timestamps, :jsonb, default: {}
    add_column :cloud_volume_backups,          :resource_timestamps, :jsonb, default: {}
    add_column :cloud_volume_snapshots,        :resource_timestamps, :jsonb, default: {}
    add_column :cloud_resource_quotas,         :resource_timestamps, :jsonb, default: {}
    add_column :flavors,                       :resource_timestamps, :jsonb, default: {}
    add_column :resource_groups,               :resource_timestamps, :jsonb, default: {}
    add_column :host_aggregates,               :resource_timestamps, :jsonb, default: {}
    add_column :orchestration_templates,       :resource_timestamps, :jsonb, default: {}
    add_column :orchestration_stacks,          :resource_timestamps, :jsonb, default: {}
    add_column :vms,                           :resource_timestamps, :jsonb, default: {}
    add_column :hardwares,                     :resource_timestamps, :jsonb, default: {}
    add_column :disks,                         :resource_timestamps, :jsonb, default: {}

    add_column :availability_zones,            :resource_timestamps_max, :datetime
    add_column :cloud_services,                :resource_timestamps_max, :datetime
    add_column :cloud_tenants,                 :resource_timestamps_max, :datetime
    add_column :cloud_object_store_containers, :resource_timestamps_max, :datetime
    add_column :cloud_object_store_objects,    :resource_timestamps_max, :datetime
    add_column :cloud_networks,                :resource_timestamps_max, :datetime
    add_column :cloud_volumes,                 :resource_timestamps_max, :datetime
    add_column :cloud_volume_backups,          :resource_timestamps_max, :datetime
    add_column :cloud_volume_snapshots,        :resource_timestamps_max, :datetime
    add_column :cloud_resource_quotas,         :resource_timestamps_max, :datetime
    add_column :flavors,                       :resource_timestamps_max, :datetime
    add_column :resource_groups,               :resource_timestamps_max, :datetime
    add_column :host_aggregates,               :resource_timestamps_max, :datetime
    add_column :orchestration_templates,       :resource_timestamps_max, :datetime
    add_column :orchestration_stacks,          :resource_timestamps_max, :datetime
    add_column :vms,                           :resource_timestamps_max, :datetime
    add_column :hardwares,                     :resource_timestamps_max, :datetime
    add_column :disks,                         :resource_timestamps_max, :datetime
  end
end
