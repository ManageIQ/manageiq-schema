class MoveBlacklistedEventsToSettingsChanges < ActiveRecord::Migration[7.0]
  class BlacklistedEvent < ActiveRecord::Base
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

  # TODO: add the rest of the provider settings keys
  # This is the mapping of BlacklistedEvent#provider_model -> SettingsChange#key
  PROVIDER_MODEL_TO_SETTINGS_KEY = {
    "ManageIQ::Providers::Vmware::InfraManager" => "/ems/ems_vmware/blacklisted_event_names"
  }.freeze

  SETTINGS_KEY_TO_PROVIDER_MODEL = {
    "/ems/ems_vmware/blacklisted_event_names" => "ManageIQ::Providers::Vmware::InfraManager"
  }.freeze

  def up
    say_with_time("Moving BlacklistedEvent records to SettingsChanges") do
      BlacklistedEvent.in_my_region.where(:system => false, :enabled => true).group_by(&:provider_model).each do |provider_model, blacklisted_events|
        addition_blacklisted_events = blacklisted_events.pluck(:event_name) - DEFAULT_BLACKLISTED_EVENTS[provider_model]
        next if addition_blacklisted_events.empty?

        settings_change_key = PROVIDER_MODEL_TO_SETTINGS_KEY[provider_model]
        next if settings_change_key.nil?

        settings_change = SettingsChange.find_or_initialize_by(:resource_type => "MiqRegion", :resource_id => SettingsChange.my_region_number, :key => settings_change_key)
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
