class ChangeResourceVersionFieldsForContainersTables < ActiveRecord::Migration[5.0]
  def up
    change_column :container_build_pods,     :resource_version, :integer, :using => 'resource_version::integer'
    change_column :container_builds,         :resource_version, :integer, :using => 'resource_version::integer'
    change_column :container_groups,         :resource_version, :integer, :using => 'resource_version::integer'
    change_column :container_limits,         :resource_version, :integer, :using => 'resource_version::integer'
    change_column :container_nodes,          :resource_version, :integer, :using => 'resource_version::integer'
    change_column :container_projects,       :resource_version, :integer, :using => 'resource_version::integer'
    change_column :container_quotas,         :resource_version, :integer, :using => 'resource_version::integer'
    change_column :container_replicators,    :resource_version, :integer, :using => 'resource_version::integer'
    change_column :container_routes,         :resource_version, :integer, :using => 'resource_version::integer'
    change_column :container_services,       :resource_version, :integer, :using => 'resource_version::integer'
    change_column :container_templates,      :resource_version, :integer, :using => 'resource_version::integer'
    change_column :container_volumes,        :resource_version, :integer, :using => 'resource_version::integer'
    change_column :persistent_volume_claims, :resource_version, :integer, :using => 'resource_version::integer'
  end

  def down
    change_column :container_build_pods,     :resource_version, :string
    change_column :container_builds,         :resource_version, :string
    change_column :container_groups,         :resource_version, :string
    change_column :container_limits,         :resource_version, :string
    change_column :container_nodes,          :resource_version, :string
    change_column :container_projects,       :resource_version, :string
    change_column :container_quotas,         :resource_version, :string
    change_column :container_replicators,    :resource_version, :string
    change_column :container_routes,         :resource_version, :string
    change_column :container_services,       :resource_version, :string
    change_column :container_templates,      :resource_version, :string
    change_column :container_volumes,        :resource_version, :string
    change_column :persistent_volume_claims, :resource_version, :string
  end
end
