class AddResourceVersionsFieldsForContainersTables < ActiveRecord::Migration[5.0]
  def change
    add_column :containers,                     :resource_version, :integer
    add_column :container_images,               :resource_version, :integer
    add_column :container_image_registries,     :resource_version, :integer
    add_column :container_conditions,           :resource_version, :integer
    add_column :security_contexts,              :resource_version, :integer
    add_column :taggings,                       :resource_version, :integer
    add_column :computer_systems,               :resource_version, :integer
    add_column :container_env_vars,             :resource_version, :integer
    add_column :container_limit_items,          :resource_version, :integer
    add_column :container_port_configs,         :resource_version, :integer
    add_column :container_quota_items,          :resource_version, :integer
    add_column :container_quota_scopes,         :resource_version, :integer
    add_column :container_service_port_configs, :resource_version, :integer
    add_column :container_template_parameters,  :resource_version, :integer
    add_column :custom_attributes,              :resource_version, :integer
    add_column :hardwares,                      :resource_version, :integer
    add_column :operating_systems,              :resource_version, :integer

    add_column :container_builds,               :resource_versions, :jsonb, default: {}
    add_column :container_build_pods,           :resource_versions, :jsonb, default: {}
    add_column :container_groups,               :resource_versions, :jsonb, default: {}
    add_column :container_limits,               :resource_versions, :jsonb, default: {}
    add_column :container_nodes,                :resource_versions, :jsonb, default: {}
    add_column :container_projects,             :resource_versions, :jsonb, default: {}
    add_column :container_quotas,               :resource_versions, :jsonb, default: {}
    add_column :container_replicators,          :resource_versions, :jsonb, default: {}
    add_column :container_routes,               :resource_versions, :jsonb, default: {}
    add_column :container_services,             :resource_versions, :jsonb, default: {}
    add_column :container_templates,            :resource_versions, :jsonb, default: {}
    add_column :containers,                     :resource_versions, :jsonb, default: {}
    add_column :persistent_volume_claims,       :resource_versions, :jsonb, default: {}
    add_column :container_images,               :resource_versions, :jsonb, default: {}
    add_column :container_image_registries,     :resource_versions, :jsonb, default: {}
    add_column :container_conditions,           :resource_versions, :jsonb, default: {}
    add_column :security_contexts,              :resource_versions, :jsonb, default: {}
    add_column :taggings,                       :resource_versions, :jsonb, default: {}
    add_column :computer_systems,               :resource_versions, :jsonb, default: {}
    add_column :container_env_vars,             :resource_versions, :jsonb, default: {}
    add_column :container_limit_items,          :resource_versions, :jsonb, default: {}
    add_column :container_port_configs,         :resource_versions, :jsonb, default: {}
    add_column :container_quota_items,          :resource_versions, :jsonb, default: {}
    add_column :container_quota_scopes,         :resource_versions, :jsonb, default: {}
    add_column :container_service_port_configs, :resource_versions, :jsonb, default: {}
    add_column :container_template_parameters,  :resource_versions, :jsonb, default: {}
    add_column :container_volumes,              :resource_versions, :jsonb, default: {}
    add_column :custom_attributes,              :resource_versions, :jsonb, default: {}
    add_column :hardwares,                      :resource_versions, :jsonb, default: {}
    add_column :operating_systems,              :resource_versions, :jsonb, default: {}

    add_column :container_builds,               :resource_versions_max, :integer
    add_column :container_build_pods,           :resource_versions_max, :integer
    add_column :container_groups,               :resource_versions_max, :integer
    add_column :container_limits,               :resource_versions_max, :integer
    add_column :container_nodes,                :resource_versions_max, :integer
    add_column :container_projects,             :resource_versions_max, :integer
    add_column :container_quotas,               :resource_versions_max, :integer
    add_column :container_replicators,          :resource_versions_max, :integer
    add_column :container_routes,               :resource_versions_max, :integer
    add_column :container_services,             :resource_versions_max, :integer
    add_column :container_templates,            :resource_versions_max, :integer
    add_column :containers,                     :resource_versions_max, :integer
    add_column :persistent_volume_claims,       :resource_versions_max, :integer
    add_column :container_images,               :resource_versions_max, :integer
    add_column :container_image_registries,     :resource_versions_max, :integer
    add_column :container_conditions,           :resource_versions_max, :integer
    add_column :security_contexts,              :resource_versions_max, :integer
    add_column :taggings,                       :resource_versions_max, :integer
    add_column :computer_systems,               :resource_versions_max, :integer
    add_column :container_env_vars,             :resource_versions_max, :integer
    add_column :container_limit_items,          :resource_versions_max, :integer
    add_column :container_port_configs,         :resource_versions_max, :integer
    add_column :container_quota_items,          :resource_versions_max, :integer
    add_column :container_quota_scopes,         :resource_versions_max, :integer
    add_column :container_service_port_configs, :resource_versions_max, :integer
    add_column :container_template_parameters,  :resource_versions_max, :integer
    add_column :container_volumes,              :resource_versions_max, :integer
    add_column :custom_attributes,              :resource_versions_max, :integer
    add_column :hardwares,                      :resource_versions_max, :integer
    add_column :operating_systems,              :resource_versions_max, :integer
  end
end
