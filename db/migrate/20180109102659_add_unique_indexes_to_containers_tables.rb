class AddUniqueIndexesToContainersTables < ActiveRecord::Migration[5.0]
  def change
    # Just having :ems_id & :ems_ref
    add_index :container_builds,         %i(ems_id ems_ref), :unique => true
    add_index :container_build_pods,     %i(ems_id ems_ref), :unique => true
    add_index :container_groups,         %i(ems_id ems_ref), :unique => true
    add_index :container_limits,         %i(ems_id ems_ref), :unique => true
    add_index :container_nodes,          %i(ems_id ems_ref), :unique => true
    add_index :container_projects,       %i(ems_id ems_ref), :unique => true
    add_index :container_quotas,         %i(ems_id ems_ref), :unique => true
    add_index :container_replicators,    %i(ems_id ems_ref), :unique => true
    add_index :container_routes,         %i(ems_id ems_ref), :unique => true
    add_index :container_services,       %i(ems_id ems_ref), :unique => true
    add_index :container_templates,      %i(ems_id ems_ref), :unique => true
    add_index :containers,               %i(ems_id ems_ref), :unique => true
    add_index :persistent_volume_claims, %i(ems_id ems_ref), :unique => true

    # Having :ems_id but not ems_ref
    add_index :container_images,
              %i(ems_id image_ref),
              :unique => true,
              :name   => "index_container_images_unique_multi_column"
    add_index :container_image_registries,
              %i(ems_id host port),
              :unique => true

    # Nested tables, not having :ems_id and the foreign_key is a part of the unique index
    add_index :container_conditions,
              %i(container_entity_id container_entity_type name),
              :unique => true,
              :name   => "index_container_conditions_unique_multi_column"
    add_index :security_contexts,
              %i(resource_id resource_type),
              :unique => true,
              :name   => "index_security_contexts_unique_multi_column"
    add_index :taggings,
              %i(taggable_id taggable_type tag_id),
              :unique => true,
              :name   => "index_taggings_unique_multi_column"
    add_index :computer_systems,
              %i(managed_entity_id managed_entity_type),
              :unique => true,
              :name   => "index_computer_systems_unique_multi_column"
    add_index :container_env_vars,
              %i(container_id name value field_path),
              :unique => true,
              :name   => "index_container_env_vars_unique_multi_column"
    add_index :container_limit_items,
              %i(container_limit_id resource item_type),
              :unique => true,
              :name   => "index_container_limit_items_unique_multi_column"
    add_index :container_port_configs,
              %i(container_id ems_ref),
              :unique => true,
              :name   => "index_container_port_configs_unique_multi_column"
    add_index :container_quota_items,
              %i(container_quota_id resource),
              :unique => true
    add_index :container_quota_scopes,
              %i(container_quota_id scope),
              :unique => true
    add_index :container_service_port_configs,
              %i(container_service_id name),
              :unique => true,
              :name   => "index_container_service_port_configs_unique_multi_column"
    add_index :container_template_parameters,
              %i(container_template_id name),
              :unique => true,
              :name   => "index_container_template_parameters_unique_multi_column"
    add_index :container_volumes,
              %i(parent_id parent_type ems_ref name),
              :unique => true,
              :name   => "index_container_volumes_unique_multi_column"
    add_index :custom_attributes,
              %i(resource_id resource_type name unique_name section source),
              :unique => true,
              :name   => "index_custom_attributes_parameters_unique_multi_column"
    add_index :hardwares,
              %i(vm_or_template_id host_id computer_system_id),
              :unique => true,
              :name   => "index_hardwares_on_unique_multi_column"
    add_index :operating_systems,
              %i(vm_or_template_id host_id computer_system_id),
              :unique => true,
              :name   => "index_operating_systems_unique_multi_column"
  end
end
