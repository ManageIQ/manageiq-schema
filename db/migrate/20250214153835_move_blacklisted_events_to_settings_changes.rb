class MoveBlacklistedEventsToSettingsChanges < ActiveRecord::Migration[7.0]
  class BlacklistedEvent < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  class MiqRegion < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  class SettingsChange < ActiveRecord::Base
    include ActiveRecord::IdRegions

    serialize :value
  end

  # The list of BlacklistedEvents without any changes to Settings
  # Any BlacklistedEvents that are not in this list must be added to SettingsChanges
  DEFAULT_BLACKLISTED_EVENTS = {
    "ManageIQ::Providers::Amazon::CloudManager"                      => ["ConfigurationSnapshotDeliveryCompleted", "ConfigurationSnapshotDeliveryStarted", "ConfigurationSnapshotDeliveryFailed"],
    "ManageIQ::Providers::Amazon::ContainerManager"                  => ["ConfigurationSnapshotDeliveryCompleted", "ConfigurationSnapshotDeliveryStarted", "ConfigurationSnapshotDeliveryFailed"],
    "ManageIQ::Providers::Amazon::NetworkManager"                    => ["ConfigurationSnapshotDeliveryCompleted", "ConfigurationSnapshotDeliveryStarted", "ConfigurationSnapshotDeliveryFailed"],
    "ManageIQ::Providers::Amazon::StorageManager::Ebs"               => ["ConfigurationSnapshotDeliveryCompleted", "ConfigurationSnapshotDeliveryStarted", "ConfigurationSnapshotDeliveryFailed"],
    "ManageIQ::Providers::Amazon::StorageManager::S3"                => ["ConfigurationSnapshotDeliveryCompleted", "ConfigurationSnapshotDeliveryStarted", "ConfigurationSnapshotDeliveryFailed"],
    "ManageIQ::Providers::Azure::CloudManager"                       => ["storageAccounts_listKeys_BeginRequest", "storageAccounts_listKeys_EndRequest", "deployments_exportTemplate_BeginRequest", "deployments_exportTemplate_EndRequest"],
    "ManageIQ::Providers::Azure::ContainerManager"                   => ["storageAccounts_listKeys_BeginRequest", "storageAccounts_listKeys_EndRequest", "deployments_exportTemplate_BeginRequest", "deployments_exportTemplate_EndRequest"],
    "ManageIQ::Providers::Azure::NetworkManager"                     => ["storageAccounts_listKeys_BeginRequest", "storageAccounts_listKeys_EndRequest", "deployments_exportTemplate_BeginRequest", "deployments_exportTemplate_EndRequest"],
    "ManageIQ::Providers::IbmCic::CloudManager"                      => ["identity.authenticate", "scheduler.run_instance.start", "scheduler.run_instance.scheduled", "scheduler.run_instance.end"],
    "ManageIQ::Providers::IbmCic::NetworkManager"                    => ["scheduler.run_instance.start", "scheduler.run_instance.scheduled", "scheduler.run_instance.end"],
    "ManageIQ::Providers::IbmCic::StorageManager::CinderManager"     => ["scheduler.run_instance.start", "scheduler.run_instance.scheduled", "scheduler.run_instance.end"],
    "ManageIQ::Providers::IbmPowerVc::CloudManager"                  => ["identity.authenticate", "scheduler.run_instance.start", "scheduler.run_instance.scheduled", "scheduler.run_instance.end"],
    "ManageIQ::Providers::IbmPowerVc::NetworkManager"                => ["scheduler.run_instance.start", "scheduler.run_instance.scheduled", "scheduler.run_instance.end"],
    "ManageIQ::Providers::IbmPowerVc::StorageManager::CinderManager" => ["scheduler.run_instance.start", "scheduler.run_instance.scheduled", "scheduler.run_instance.end"],
    "ManageIQ::Providers::Openstack::CloudManager"                   => ["identity.authenticate", "scheduler.run_instance.start", "scheduler.run_instance.scheduled", "scheduler.run_instance.end"],
    "ManageIQ::Providers::Openstack::InfraManager"                   => ["identity.authenticate"],
    "ManageIQ::Providers::Openstack::NetworkManager"                 => ["scheduler.run_instance.start", "scheduler.run_instance.scheduled", "scheduler.run_instance.end"],
    "ManageIQ::Providers::Openstack::StorageManager::CinderManager"  => ["scheduler.run_instance.start", "scheduler.run_instance.scheduled", "scheduler.run_instance.end"],
    "ManageIQ::Providers::OracleCloud::CloudManager"                 => ["com.oraclecloud.resourcequeryservice.searchresources", "com.oraclecloud.identitysignon.federatedinteractiveloginattempt", "serviceapi"],
    "ManageIQ::Providers::OracleCloud::ContainerManager"             => ["com.oraclecloud.resourcequeryservice.searchresources", "com.oraclecloud.identitysignon.federatedinteractiveloginattempt", "serviceapi"],
    "ManageIQ::Providers::OracleCloud::NetworkManager"               => ["com.oraclecloud.resourcequeryservice.searchresources", "com.oraclecloud.identitysignon.federatedinteractiveloginattempt", "serviceapi"],
    "ManageIQ::Providers::Ovirt::InfraManager"                       => ["UNASSIGNED", "USER_REMOVE_VG", "USER_REMOVE_VG_FAILED", "USER_VDC_LOGIN", "USER_VDC_LOGIN_FAILED", "USER_VDC_LOGOUT"],
    "ManageIQ::Providers::Ovirt::NetworkManager"                     => ["scheduler.run_instance.end", "scheduler.run_instance.scheduled", "scheduler.run_instance.start"],
    "ManageIQ::Providers::Redhat::InfraManager"                      => ["UNASSIGNED", "USER_REMOVE_VG", "USER_REMOVE_VG_FAILED", "USER_VDC_LOGIN", "USER_VDC_LOGIN_FAILED", "USER_VDC_LOGOUT"],
    "ManageIQ::Providers::Redhat::NetworkManager"                    => ["scheduler.run_instance.end", "scheduler.run_instance.scheduled", "scheduler.run_instance.start"],
    "ManageIQ::Providers::Vmware::InfraManager"                      => ["AlarmActionTriggeredEvent", "AlarmCreatedEvent", "AlarmEmailCompletedEvent", "AlarmEmailFailedEvent", "AlarmReconfiguredEvent", "AlarmRemovedEvent", "AlarmScriptCompleteEvent", "AlarmScriptFailedEvent", "AlarmSnmpCompletedEvent", "AlarmSnmpFailedEvent", "AlarmStatusChangedEvent", "AlreadyAuthenticatedSessionEvent", "EventEx", "UserLoginSessionEvent", "UserLogoutSessionEvent"]
  }.freeze

  # The mapping of BlacklistedEvent#provider_model -> SettingsChange#key
  PROVIDER_MODEL_TO_SETTINGS_KEY = {
    "ManageIQ::Providers::Amazon::CloudManager"                  => "/ems/ems_amazon/blacklisted_event_names",
    "ManageIQ::Providers::AnsibleTower::AutomationManager"       => "/ems/ems_ansible_tower/blacklisted_event_names",
    "ManageIQ::Providers::Autosde::StorageManager"               => "/ems/ems_autosde/blacklisted_event_names",
    "ManageIQ::Providers::Awx::AutomationManager"                => "/ems/ems_awx/blacklisted_event_names",
    "ManageIQ::Providers::Azure::CloudManager"                   => "/ems/ems_azure/blacklisted_event_names",
    "ManageIQ::Providers::AzureStack::CloudManager"              => "/ems/ems_azure_stack/blacklisted_event_names",
    "ManageIQ::Providers::CiscoIntersight::PhysicalInfraManager" => "/ems/ems_cisco_intersight/blacklisted_event_names",
    "ManageIQ::Providers::EmbeddedTerraform::AutomationManager"  => "/ems/ems_embedded_terraform/blacklisted_event_names",
    "ManageIQ::Providers::Foreman::ConfigurationManager"         => "/ems/ems_foreman/blacklisted_event_names",
    "ManageIQ::Providers::Google::CloudManager"                  => "/ems/ems_google/blacklisted_event_names",
    "ManageIQ::Providers::IbmCic::CloudManager"                  => "/ems/ems_ibm_cic/blacklisted_event_names",
    "ManageIQ::Providers::IbmPowerHmc::InfraManager"             => "/ems/ems_ibm_power_hmc/blacklisted_event_names",
    "ManageIQ::Providers::IbmPowerVc::CloudManager"              => "/ems/ems_ibm_power_vc/blacklisted_event_names",
    "ManageIQ::Providers::IbmTerraform::ConfigurationManager"    => "/ems/ems_ibm_terraform/blacklisted_event_names",
    "ManageIQ::Providers::Kubernetes::ContainerManager"          => "/ems/ems_kubernetes/blacklisted_event_names",
    "ManageIQ::Providers::Kubevirt::InfraManager"                => "/ems/ems_kubevirt/blacklisted_event_names",
    "ManageIQ::Providers::Lenovo::PhysicalInfraManager"          => "/ems/ems_lenovo/blacklisted_event_names",
    "ManageIQ::Providers::Nsxt::NetworkManager"                  => "/ems/ems_nsxt/blacklisted_event_names",
    "ManageIQ::Providers::Nuage::NetworkManager"                 => "/ems/ems_nuage/blacklisted_event_names",
    "ManageIQ::Providers::Openshift::ContainerManager"           => "/ems/ems_openshift/blacklisted_event_names",
    "ManageIQ::Providers::Openstack::CloudManager"               => "/ems/ems_openstack/blacklisted_event_names",
    "ManageIQ::Providers::OracleCloud::CloudManager"             => "/ems/ems_oracle_cloud/blacklisted_event_names",
    "ManageIQ::Providers::Ovirt::InfraManager"                   => "/ems/ems_ovirt/blacklisted_event_names",
    "ManageIQ::Providers::Ovirt::NetworkManager"                 => "/ems/ems_ovirt_network/blacklisted_event_names",
    "ManageIQ::Providers::Redfish::PhysicalInfraManager"         => "/ems/ems_redfish/blacklisted_event_names",
    "ManageIQ::Providers::Redhat::InfraManager"                  => "/ems/ems_redhat/blacklisted_event_names",
    "ManageIQ::Providers::Redhat::NetworkManager"                => "/ems/ems_redhat_network/blacklisted_event_names",
    "ManageIQ::Providers::Vmware::InfraManager"                  => "/ems/ems_vmware/blacklisted_event_names",
    "ManageIQ::Providers::Vmware::CloudManager"                  => "/ems/ems_vmware_cloud/blacklisted_event_names",
    "ManageIQ::Providers::Vmware::NetworkManager"                => "/ems/ems_vmware_cloud_network/blacklisted_event_names",
    "ManageIQ::Providers::Vmware::ContainerManager"              => "/ems/ems_vmware_tanzu/blacklisted_event_names",
    "ManageIQ::Providers::Workflows::AutomationManager"          => "/ems/ems_workflows/blacklisted_event_names"
  }.freeze

  SETTINGS_KEY_TO_PROVIDER_MODEL = PROVIDER_MODEL_TO_SETTINGS_KEY.invert

  def up
    say_with_time("Moving BlacklistedEvent records to SettingsChanges") do
      my_region_id = MiqRegion.find_by(:region => MiqRegion.my_region_number)&.id
      return if my_region_id.nil?

      BlacklistedEvent.in_my_region.where(:system => false, :enabled => true).group_by(&:provider_model).each do |provider_model, blacklisted_events|
        addition_blacklisted_events = blacklisted_events.pluck(:event_name) - DEFAULT_BLACKLISTED_EVENTS[provider_model]
        next if addition_blacklisted_events.empty?

        settings_change_key = PROVIDER_MODEL_TO_SETTINGS_KEY[provider_model]
        next if settings_change_key.nil?

        settings_change = SettingsChange.find_or_initialize_by(:resource_type => "MiqRegion", :resource_id => my_region_id, :key => settings_change_key)
        settings_change.update!(:value => DEFAULT_BLACKLISTED_EVENTS[provider_model] + addition_blacklisted_events)
      end
    end
  end

  def down
    say_with_time("Moving SettingsChanges to BlacklistedEvents") do
      SettingsChange.in_my_region.where(:key => PROVIDER_MODEL_TO_SETTINGS_KEY.values).each do |settings_change|
        provider_model = SETTINGS_KEY_TO_PROVIDER_MODEL[settings_change.key]
        next if provider_model.nil?

        default_filtered_events = DEFAULT_BLACKLISTED_EVENTS[provider_model]
        next if default_filtered_events.nil?

        addition_blacklisted_events = settings_change.value - default_filtered_events
        addition_blacklisted_events.each do |event_name|
          BlacklistedEvent.create!(:provider_model => provider_model, :event_name => event_name, :system => false, :enabled => true)
        end
      end
    end
  end
end
