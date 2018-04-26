class AddTableComments < ActiveRecord::Migration[5.0]
  def up
    change_table_comment :accounts, ""
    change_table_comment :advanced_settings, ""
    change_table_comment :arbitration_profiles, ""
    change_table_comment :arbitration_rules, ""
    change_table_comment :arbitration_settings, ""
    change_table_comment :assigned_server_roles, "Internal: Join table to show relation between MiqServers and their ServerRoles"
    change_table_comment :audit_events, ""
    change_table_comment :authentications, "Internal: A safe place to store credentials used to authenticate with other services (reversible encrypted)"
    change_table_comment :availability_zones, ""
    change_table_comment :binary_blob_parts, "Internal: parts of BinaryBlobs"
    change_table_comment :binary_blobs, "Internal: Used to store binary data in the database.  Blobs are split into many BinaryBlobParts."
    change_table_comment :blacklisted_events, ""
    change_table_comment :blueprints, ""
    change_table_comment :bottleneck_events, ""
    change_table_comment :chargeback_rate_detail_currencies, ""
    change_table_comment :chargeback_rate_detail_measures, ""
    change_table_comment :chargeback_rate_details, ""
    change_table_comment :chargeback_rates, ""
    change_table_comment :chargeback_tiers, ""
    change_table_comment :classifications, "Internal: Tag Categories"
    change_table_comment :cloud_database_flavors, ""
    change_table_comment :cloud_databases, ""
    change_table_comment :cloud_networks, ""
    change_table_comment :cloud_object_store_containers, ""
    change_table_comment :cloud_object_store_objects, ""
    change_table_comment :cloud_resource_quotas, ""
    change_table_comment :cloud_services, ""
    change_table_comment :cloud_subnets, ""
    change_table_comment :cloud_subnets_network_ports, ""
    change_table_comment :cloud_tenant_flavors, ""
    change_table_comment :cloud_tenants, ""
    change_table_comment :cloud_tenants_vms, ""
    change_table_comment :cloud_volume_backups, ""
    change_table_comment :cloud_volume_snapshots, ""
    change_table_comment :cloud_volumes, ""
    change_table_comment :compliance_details, ""
    change_table_comment :compliances, ""
    change_table_comment :computer_systems, "Abstraction: A single place that can store common attributes and relations for a 'computer' such as hardware information, operating system and relation back to the object that represents the provider object."
    change_table_comment :conditions, ""
    change_table_comment :conditions_miq_policies, ""
    change_table_comment :configuration_locations, "Providers: Representation of an organizations and/or sub-organizations"
    change_table_comment :configuration_locations_configuration_profiles, "Internal: Join table between ConfigurationLocations and ConfigurationProfiles"
    change_table_comment :configuration_organizations, "Providers: Representation of an organizations and/or sub-organizations"
    change_table_comment :configuration_organizations_configuration_profiles, "Internal: Join table between ConfigurationOrganizations and ConfigurationProfiles"
    change_table_comment :configuration_profiles, "Providers: Representation of existing profiles (aggregation of ConfigurationScripts) that can be applied to a ConfiguredSystems"
    change_table_comment :configuration_profiles_configuration_tags, "Internal: Join table between ConfigurationProfiles and ConfigurationTags"
    change_table_comment :configuration_scripts, "Providers: Representation of existing scripts that can be part of ConfigurationProfiles and applied to ConfiguredSystems"
    change_table_comment :configuration_tags, ""
    change_table_comment :configuration_tags_configured_systems, "Internal: Join table between ConfigurationTags and ConfiguredSystems"
    change_table_comment :configured_systems, "Providers: Representation of a system that is managed by a ConfigurationManager ('host' in Foreman / Ansible Tower)"
    change_table_comment :container_build_pods, ""
    change_table_comment :container_builds, ""
    change_table_comment :container_component_statuses, ""
    change_table_comment :container_conditions, ""
    change_table_comment :container_definitions, ""
    change_table_comment :container_deployment_nodes, ""
    change_table_comment :container_deployments, ""
    change_table_comment :container_env_vars, ""
    change_table_comment :container_groups, "Providers: Groups of containers that form a component of an application"
    change_table_comment :container_groups_container_services, ""
    change_table_comment :container_image_registries, ""
    change_table_comment :container_images, "Providers: Images used to deploy containers"
    change_table_comment :container_label_tag_mappings, ""
    change_table_comment :container_limit_items, ""
    change_table_comment :container_limits, ""
    change_table_comment :container_nodes, ""
    change_table_comment :container_port_configs, ""
    change_table_comment :container_projects, ""
    change_table_comment :container_quota_items, ""
    change_table_comment :container_quotas, ""
    change_table_comment :container_replicators, ""
    change_table_comment :container_routes, ""
    change_table_comment :container_service_port_configs, ""
    change_table_comment :container_services, "Providers: Services within a ContainerProject that group and load balance across many ContainerGroups"
    change_table_comment :container_template_parameters, ""
    change_table_comment :container_templates, ""
    change_table_comment :container_volumes, ""
    change_table_comment :containers, "Providers: Representation of a running container"
    change_table_comment :custom_attributes, "Internal: key / value pairs that can be attached to other objects in the system"
    change_table_comment :custom_buttons, ""
    change_table_comment :customization_scripts, "Providers: Scripts that can be run on a system to customize OS installation"
    change_table_comment :customization_scripts_operating_system_flavors, "Internal: Join table between CustomizationScripts and OperatingSystemFlavors"
    change_table_comment :customization_specs, "Providers: Vmware customization specs"
    change_table_comment :customization_templates, ""
    change_table_comment :database_backups, ""
    change_table_comment :dialog_fields, "Internal: A field on a dialog"
    change_table_comment :dialog_groups, "Internal: A group of fields on a dialog"
    change_table_comment :dialog_tabs, "Internal: A tab on a dialog"
    change_table_comment :dialogs, "Internal: A dialog"
    change_table_comment :direct_configuration_profiles_configuration_tags, ""
    change_table_comment :direct_configuration_tags_configured_systems, ""
    change_table_comment :disks, ""
    change_table_comment :drift_states, ""
    change_table_comment :ems_clusters, "Providers: A representation of a cluster of hypervisors"
    change_table_comment :ems_folders, "Providers: A nestable hierarchy of folders"
    change_table_comment :endpoints, "Providers: Provider endpoint connection information"
    change_table_comment :entitlements, ""
    change_table_comment :event_logs, ""
    change_table_comment :event_streams, ""
    change_table_comment :ext_management_systems, "Providers: Representation of a manager of things (vm / storage / network / etc.) can be single type or multiple type"
    change_table_comment :file_depots, "Internal: External storage locations (NFS / SMB / FTP) that can be used to upload files or logs"
    change_table_comment :filesystems, ""
    change_table_comment :firewall_rules, "Providers: Firewall rules applied to a cloud instance"
    change_table_comment :flavors, "Providers: Representation of cloud instance hardware profiles"
    change_table_comment :floating_ips, "Providers: Representation of cloud floating IP addresses"
    change_table_comment :generic_object_definitions, ""
    change_table_comment :generic_objects, ""
    change_table_comment :git_references, ""
    change_table_comment :git_repositories, ""
    change_table_comment :guest_applications, ""
    change_table_comment :guest_devices, "Providers: Hardware devices attached to Hardwares to provide specific device information (NICs / PCI devices / etc.)"
    change_table_comment :hardwares, "Providers: Hardware inventory for a system"
    change_table_comment :host_aggregate_hosts, ""
    change_table_comment :host_aggregates, ""
    change_table_comment :host_service_groups, ""
    change_table_comment :host_storages, ""
    change_table_comment :host_switches, ""
    change_table_comment :hosts, ""
    change_table_comment :import_file_uploads, ""
    change_table_comment :iso_datastores, "Providers: Representation of datastores containing only ISO images"
    change_table_comment :iso_images, "Providers: ISO images on a datastore"
    change_table_comment :jobs, ""
    change_table_comment :key_pairs_vms, ""
    change_table_comment :lans, ""
    change_table_comment :ldap_domains, ""
    change_table_comment :ldap_groups, ""
    change_table_comment :ldap_managements, ""
    change_table_comment :ldap_regions, ""
    change_table_comment :ldap_servers, ""
    change_table_comment :ldap_users, ""
    change_table_comment :lifecycle_events, ""
    change_table_comment :load_balancer_health_check_members, ""
    change_table_comment :load_balancer_health_checks, ""
    change_table_comment :load_balancer_listener_pools, ""
    change_table_comment :load_balancer_listeners, ""
    change_table_comment :load_balancer_pool_member_pools, ""
    change_table_comment :load_balancer_pool_members, ""
    change_table_comment :load_balancer_pools, ""
    change_table_comment :load_balancers, ""
    change_table_comment :log_files, "Internal: Log files that have been uploaded to a FileDepot"
    change_table_comment :metric_rollups, ""
    change_table_comment :metric_rollups_01, "Internal: monthly sub-table of metric_rollups"
    change_table_comment :metric_rollups_02, "Internal: monthly sub-table of metric_rollups"
    change_table_comment :metric_rollups_03, "Internal: monthly sub-table of metric_rollups"
    change_table_comment :metric_rollups_04, "Internal: monthly sub-table of metric_rollups"
    change_table_comment :metric_rollups_05, "Internal: monthly sub-table of metric_rollups"
    change_table_comment :metric_rollups_06, "Internal: monthly sub-table of metric_rollups"
    change_table_comment :metric_rollups_07, "Internal: monthly sub-table of metric_rollups"
    change_table_comment :metric_rollups_08, "Internal: monthly sub-table of metric_rollups"
    change_table_comment :metric_rollups_09, "Internal: monthly sub-table of metric_rollups"
    change_table_comment :metric_rollups_10, "Internal: monthly sub-table of metric_rollups"
    change_table_comment :metric_rollups_11, "Internal: monthly sub-table of metric_rollups"
    change_table_comment :metric_rollups_12, "Internal: monthly sub-table of metric_rollups"
    change_table_comment :metrics, ""
    change_table_comment :metrics_00, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_01, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_02, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_03, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_04, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_05, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_06, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_07, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_08, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_09, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_10, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_11, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_12, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_13, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_14, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_15, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_16, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_17, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_18, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_19, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_20, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_21, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_22, "Internal: hourly sub-table of metrics"
    change_table_comment :metrics_23, "Internal: hourly sub-table of metrics"
    change_table_comment :middleware_datasources, ""
    change_table_comment :middleware_deployments, ""
    change_table_comment :middleware_domains, ""
    change_table_comment :middleware_messagings, ""
    change_table_comment :middleware_server_groups, ""
    change_table_comment :middleware_servers, ""
    change_table_comment :miq_actions, ""
    change_table_comment :miq_ae_classes, ""
    change_table_comment :miq_ae_fields, ""
    change_table_comment :miq_ae_instances, ""
    change_table_comment :miq_ae_methods, ""
    change_table_comment :miq_ae_namespaces, ""
    change_table_comment :miq_ae_values, ""
    change_table_comment :miq_ae_workspaces, ""
    change_table_comment :miq_alert_statuses, ""
    change_table_comment :miq_alerts, ""
    change_table_comment :miq_approvals, ""
    change_table_comment :miq_cim_associations, ""
    change_table_comment :miq_cim_derived_metrics, ""
    change_table_comment :miq_cim_instances, ""
    change_table_comment :miq_databases, "Internal: Single non-replicated row to store information about the database and application"
    change_table_comment :miq_dialogs, ""
    change_table_comment :miq_enterprises, "Internal: Enterprise has many regions"
    change_table_comment :miq_event_definitions, ""
    change_table_comment :miq_globals, ""
    change_table_comment :miq_groups, ""
    change_table_comment :miq_groups_users, ""
    change_table_comment :miq_policies, ""
    change_table_comment :miq_policy_contents, ""
    change_table_comment :miq_product_features, ""
    change_table_comment :miq_queue, "Internal: Queue for background workers"
    change_table_comment :miq_regions, "Internal: Single (replicated) row for each region"
    change_table_comment :miq_report_result_details, ""
    change_table_comment :miq_report_results, ""
    change_table_comment :miq_reports, ""
    change_table_comment :miq_request_tasks, "Internal: A request can create many request tasks which will be processed by background workers"
    change_table_comment :miq_requests, "Internal: A request is created once a dialog is submitted"
    change_table_comment :miq_roles_features, ""
    change_table_comment :miq_schedules, ""
    change_table_comment :miq_scsi_luns, ""
    change_table_comment :miq_scsi_targets, ""
    change_table_comment :miq_searches, ""
    change_table_comment :miq_servers, "Internal: All servers in the region"
    change_table_comment :miq_sets, ""
    change_table_comment :miq_shortcuts, ""
    change_table_comment :miq_storage_metrics, ""
    change_table_comment :miq_tasks, ""
    change_table_comment :miq_user_roles, ""
    change_table_comment :miq_widget_contents, ""
    change_table_comment :miq_widget_shortcuts, ""
    change_table_comment :miq_widgets, ""
    change_table_comment :miq_workers, "Internal: All workers in the region"
    change_table_comment :network_groups, ""
    change_table_comment :network_ports, ""
    change_table_comment :network_ports_security_groups, ""
    change_table_comment :network_routers, ""
    change_table_comment :networks, ""
    change_table_comment :notification_recipients, ""
    change_table_comment :notification_types, ""
    change_table_comment :notifications, ""
    change_table_comment :ontap_aggregate_derived_metrics, ""
    change_table_comment :ontap_aggregate_metrics_rollups, ""
    change_table_comment :ontap_disk_derived_metrics, ""
    change_table_comment :ontap_disk_metrics_rollups, ""
    change_table_comment :ontap_lun_derived_metrics, ""
    change_table_comment :ontap_lun_metrics_rollups, ""
    change_table_comment :ontap_system_derived_metrics, ""
    change_table_comment :ontap_system_metrics_rollups, ""
    change_table_comment :ontap_volume_derived_metrics, ""
    change_table_comment :ontap_volume_metrics_rollups, ""
    change_table_comment :openscap_results, ""
    change_table_comment :openscap_rule_results, ""
    change_table_comment :operating_system_flavors, ""
    change_table_comment :operating_systems, ""
    change_table_comment :orchestration_stack_outputs, ""
    change_table_comment :orchestration_stack_parameters, ""
    change_table_comment :orchestration_stack_resources, ""
    change_table_comment :orchestration_stacks, ""
    change_table_comment :orchestration_templates, ""
    change_table_comment :os_processes, ""
    change_table_comment :partitions, ""
    change_table_comment :patches, ""
    change_table_comment :persistent_volume_claims, ""
    change_table_comment :pictures, "Internal: Allows for custom images to be uploaded and used in the UI"
    change_table_comment :policy_event_contents, ""
    change_table_comment :policy_events, ""
    change_table_comment :providers, "Internal: A collection of managers / ext_management_systems that represent a whole installation of another management system which is managed"
    change_table_comment :pxe_image_types, "Internal: grouping of PXE images by type"
    change_table_comment :pxe_images, "Providers: PXE images found on a PXE server"
    change_table_comment :pxe_menus, "Providers: PXE menus on a PXE server"
    change_table_comment :pxe_servers, "Providers: PXE servers"
    change_table_comment :registry_items, ""
    change_table_comment :relationships, ""
    change_table_comment :repositories, ""
    change_table_comment :reserves, ""
    change_table_comment :resource_actions, ""
    change_table_comment :resource_groups, ""
    change_table_comment :resource_pools, ""
    change_table_comment :rss_feeds, ""
    change_table_comment :scan_histories, ""
    change_table_comment :scan_items, ""
    change_table_comment :security_contexts, ""
    change_table_comment :security_groups, ""
    change_table_comment :security_groups_vms, ""
    change_table_comment :server_roles, "Internal: All roles that a server may have"
    change_table_comment :service_orders, ""
    change_table_comment :service_resources, ""
    change_table_comment :service_template_catalogs, ""
    change_table_comment :service_templates, ""
    change_table_comment :services, ""
    change_table_comment :sessions, ""
    change_table_comment :settings_changes, "Internal: Individual changes applied to the settings and location in the inheritence tree"
    change_table_comment :snapshots, ""
    change_table_comment :storage_files, ""
    change_table_comment :storage_managers, ""
    change_table_comment :storage_metrics_metadata, ""
    change_table_comment :storage_profile_storages, ""
    change_table_comment :storage_profiles, ""
    change_table_comment :storages, ""
    change_table_comment :storages_vms_and_templates, ""
    change_table_comment :switches, ""
    change_table_comment :system_consoles, ""
    change_table_comment :system_services, ""
    change_table_comment :taggings, ""
    change_table_comment :tags, ""
    change_table_comment :tenant_quotas, ""
    change_table_comment :tenants, ""
    change_table_comment :time_profiles, ""
    change_table_comment :users, ""
    change_table_comment :vim_performance_operating_ranges, ""
    change_table_comment :vim_performance_states, ""
    change_table_comment :vim_performance_tag_values, ""
    change_table_comment :vmdb_database_metrics, ""
    change_table_comment :vmdb_databases, ""
    change_table_comment :vmdb_indexes, ""
    change_table_comment :vmdb_metrics, ""
    change_table_comment :vmdb_tables, ""
    change_table_comment :vms, "Providers: Virtual machines and templates"
    change_table_comment :volumes, ""
    change_table_comment :windows_images, "Providers: PXE servers may also serve windows images for installation"
    change_table_comment :zones, "Internal: Used to group servers within a region"
  end
end
