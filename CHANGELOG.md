# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)


## Unreleased as of Sprint 93 ending 2018-08-27

### Added
- Model relation "SecurityGroup belongs to NetworkRouter or CloudSubnet" [(#258)](https://github.com/ManageIQ/manageiq-schema/pull/258)
- Update default of internal attribute in service template [(#251)](https://github.com/ManageIQ/manageiq-schema/pull/251)
- Create a ConversionHost table [(#242)](https://github.com/ManageIQ/manageiq-schema/pull/242)
- Migrate Nuage CloudSubnet default type to new subclass [(#215)](https://github.com/ManageIQ/manageiq-schema/pull/215)

## Unreleased as of Sprint 92 ending 2018-08-13

### Added
- Enable S3 DB Backups [(#227)](https://github.com/ManageIQ/manageiq-schema/pull/227)

### Fixed
- Change backtick to single quote [(#246)](https://github.com/ManageIQ/manageiq-schema/pull/246)
- Add internal column to ServiceTemplate table [(#238)](https://github.com/ManageIQ/manageiq-schema/pull/238)

## Unreleased as of Sprint 91 ending 2018-07-30

### Added
- Adding Location LED name to asset_details table [(#231)](https://github.com/ManageIQ/manageiq-schema/pull/231)
- Add physical_switch_id and physical_chassis_id column to event stream table [(#229)](https://github.com/ManageIQ/manageiq-schema/pull/229)
- Enable PhysicalStorage inside PhysicalChassis [(#224)](https://github.com/ManageIQ/manageiq-schema/pull/224)
- Create table for Cloud Volume Types [(#223)](https://github.com/ManageIQ/manageiq-schema/pull/223)
- Allow FloatingIp to relate directly to NetworkRouter [(#217)](https://github.com/ManageIQ/manageiq-schema/pull/217)

### Removed
- Remove Settings.product.transformation [(#236)](https://github.com/ManageIQ/manageiq-schema/pull/236)

## Unreleased as of Sprint 89 ending 2018-07-02

### Added
- Add ems_ref to lans to help with unique listing [(#226)](https://github.com/ManageIQ/manageiq-schema/pull/226)
- Add Firmware Type to Hardwares [(#221)](https://github.com/ManageIQ/manageiq-schema/pull/221)
- Add a Status column to Storages [(#220)](https://github.com/ManageIQ/manageiq-schema/pull/220)
- Add two columns title and cves to OpenscapRuleResults table [(#214)](https://github.com/ManageIQ/manageiq-schema/pull/214)
- Adding column on physical_network_ports table to connect other ports [(#208)](https://github.com/ManageIQ/manageiq-schema/pull/208)
- Add index on STI type columns [(#190)](https://github.com/ManageIQ/manageiq-schema/pull/190)
- Add configuration_script_sources.last_update_error [(#187)](https://github.com/ManageIQ/manageiq-schema/pull/187)

### Fixed
- Fix the quadicon settings migration for users without quadicon settings [(#225)](https://github.com/ManageIQ/manageiq-schema/pull/225)
- Convert user quadicon settings from the old format to the new one [(#213)](https://github.com/ManageIQ/manageiq-schema/pull/213)

## Unreleased as of Sprint 88 ending 2018-06-18

### Fixed
- Clean Azure image names [(#198)](https://github.com/ManageIQ/manageiq-schema/pull/198)

## Unreleased as of Sprint 87 ending 2018-06-04

### Added
- Add deleted_on to ServiceTemplate for archival [(#207)](https://github.com/ManageIQ/manageiq-schema/pull/207)
- Creating Physical Storage table [(#196)](https://github.com/ManageIQ/manageiq-schema/pull/196)

## Gaprindashvili-3 released 2018-05-15

### Fixed
- Move SchemaMigration model from ManageIQ to ManageIQ::Schema plugin [(#175)](https://github.com/ManageIQ/manageiq-schema/pull/175)
- Remove the limits from the tables in sorted order [(#179)](https://github.com/ManageIQ/manageiq-schema/pull/179)

## Unreleased as of Sprint 85 ending 2018-05-07

### Added
- Creating physical_network_ports table [(#185)](https://github.com/ManageIQ/manageiq-schema/pull/185)

### Fixed
- Azure backslash to forward slash [(#192)](https://github.com/ManageIQ/manageiq-schema/pull/192)
- Nil MiqDatabase#update_repo_name [(#191)](https://github.com/ManageIQ/manageiq-schema/pull/191)

### Removed
- Remove all VMware MKS console-related records from SettingSchanges [(#166)](https://github.com/ManageIQ/manageiq-schema/pull/166)

## Unreleased as of Sprint 84 ending 2018-04-23

### Added
- Create a Physical Chassis table [(#183)](https://github.com/ManageIQ/manageiq-schema/pull/183)
- Updating details for physical switches [(#182)](https://github.com/ManageIQ/manageiq-schema/pull/182)

### Fixed
- Update provider_region to nil for Google provider [(#184)](https://github.com/ManageIQ/manageiq-schema/pull/184)

## Unreleased as of Sprint 83 ending 2018-04-09

### Added
- Add compliance information [(#169)](https://github.com/ManageIQ/manageiq-schema/pull/169)

### Fixed
- Set the switch types for VMware switches [(#180)](https://github.com/ManageIQ/manageiq-schema/pull/180)

## Unreleased as of Sprint 82 ending 2018-03-26

### Added
- Add vm_ems_ref to event_streams [(#176)](https://github.com/ManageIQ/manageiq-schema/pull/176)
- Add miq_task_id column to miq_queue table [(#167)](https://github.com/ManageIQ/manageiq-schema/pull/167)
- Add lan info to a guest_device (port) [(#165)](https://github.com/ManageIQ/manageiq-schema/pull/165)
- Updating switches data [(#160)](https://github.com/ManageIQ/manageiq-schema/pull/160)

### Fixed
- Adding product details columns to asset_details table [(#181)](https://github.com/ManageIQ/manageiq-schema/pull/181)

### Removed
- Remove all instances of ManageIQ::Providers::Hawkular::MiddlewareManager from ext_management_systems [(#161)](https://github.com/ManageIQ/manageiq-schema/pull/161)

## Unreleased as of Sprint 80 ending 2018-02-26

### Added
- Add last_updated_on to configuration_script_sources [(#172)](https://github.com/ManageIQ/manageiq-schema/pull/172)
- Add ems_ref column to physical_racks table [(#170)](https://github.com/ManageIQ/manageiq-schema/pull/170)
- Add hostname to Vm [(#168)](https://github.com/ManageIQ/manageiq-schema/pull/168)
- create a physical rack table [(#156)](https://github.com/ManageIQ/manageiq-schema/pull/156)

### Fixed
- nil out invalid hostnames on MiqServer records [(#164)](https://github.com/ManageIQ/manageiq-schema/pull/164)

## Gaprindashvili-1 - Released 2018-01-31

### Added
- Add unique_set_size for servers and workers [(#139)](https://github.com/ManageIQ/manageiq-schema/pull/139)
- Migrate Zone NTP settings to SettingsChanges [(#122)](https://github.com/ManageIQ/manageiq-schema/pull/122)
- Update ResourceGroup type for Azure [(#131)](https://github.com/ManageIQ/manageiq-schema/pull/131)
- Add user_id group_id tenant_id to MiqQueue [(#83)](https://github.com/ManageIQ/manageiq-schema/pull/83)
- Add severity column to miq_alerts table [(#77)](https://github.com/ManageIQ/manageiq-schema/pull/77)
- Change the table used for LXCA config patterns [(#75)](https://github.com/ManageIQ/manageiq-schema/pull/75)
- Add parent/child support for lans as well as subnets [(#69)](https://github.com/ManageIQ/manageiq-schema/pull/69)
- Change dialog field description to text field to accomodate larger sizes [(#73)](https://github.com/ManageIQ/manageiq-schema/pull/73)
- Add an ID to the event that refer to origin system's event [(#70)](https://github.com/ManageIQ/manageiq-schema/pull/70)
- Adding scan_results table for ScanResult model [(#57)](https://github.com/ManageIQ/manageiq-schema/pull/57)
- Update orchestration template types [(#55)](https://github.com/ManageIQ/manageiq-schema/pull/55)
- Add numeric columns to Container Quota Items [(#44)](https://github.com/ManageIQ/manageiq-schema/pull/44)
- Models for tiers in showback [(#66)](https://github.com/ManageIQ/manageiq-schema/pull/66)
- Add serial_number to hardware [(#63)](https://github.com/ManageIQ/manageiq-schema/pull/63)
- Add schema support for LXCA config patterns [(#61)](https://github.com/ManageIQ/manageiq-schema/pull/61)
- Add container_project_id to persistent_volume_claims [(#60)](https://github.com/ManageIQ/manageiq-schema/pull/60)
- Add object_labels to Container Template [(#32)](https://github.com/ManageIQ/manageiq-schema/pull/32)
- Added AutomateWorkspace which can be retrieved using REST API [(#50)](https://github.com/ManageIQ/manageiq-schema/pull/50)
- Add hash_expression to MiqAlert [(#49)](https://github.com/ManageIQ/manageiq-schema/pull/49)
- Migrate the roles that we live migrate at startup [(#58)](https://github.com/ManageIQ/manageiq-schema/pull/58)
- Add expression to entitlements [(#47)](https://github.com/ManageIQ/manageiq-schema/pull/47)
- Add Resource to OpenSCAP results [(#42)](https://github.com/ManageIQ/manageiq-schema/pull/42)
- Add DialogFieldAssociation table [(#41)](https://github.com/ManageIQ/manageiq-schema/pull/41)
- Custom fonticons and colors in the CustomButton(Set) model [(#39)](https://github.com/ManageIQ/manageiq-schema/pull/39)
- Add type to ContainerTemplate to allow subclassing. [(#35)](https://github.com/ManageIQ/manageiq-schema/pull/35)
- Migrations for merging container_definition and container [(#24)](https://github.com/ManageIQ/manageiq-schema/pull/24)
- Add options to ems [(#23)](https://github.com/ManageIQ/manageiq-schema/pull/23)

### Fixed
- Move the db:check_schema task to the public tasks.rake file [(#124)](https://github.com/ManageIQ/manageiq-schema/pull/124)
- Require the activerecord extension from the pg-pglogical gem [(#126)](https://github.com/ManageIQ/manageiq-schema/pull/126)
- Remove the limit from string columns in all tables [(#125)](https://github.com/ManageIQ/manageiq-schema/pull/125)
- Downcase ems_ref for Azure resource groups [(#123)](https://github.com/ManageIQ/manageiq-schema/pull/123)
- Fix migration column caching. [(#136)](https://github.com/ManageIQ/manageiq-schema/pull/136)
- Add columns for mw domain entities in event streams table [(#86)](https://github.com/ManageIQ/manageiq-schema/pull/86)
- Rename the provisioning_manager_id column in the customization_scripts table [(#85)](https://github.com/ManageIQ/manageiq-schema/pull/85)
- Change rake spec to run all specs and be the default [(#78)](https://github.com/ManageIQ/manageiq-schema/pull/78)
- Fix migration name typo: s/shorback/showback/ [(#76)](https://github.com/ManageIQ/manageiq-schema/pull/76)
- Fix db:migrate:reset by setting DatabaseTasks.migrations_paths [(#68)](https://github.com/ManageIQ/manageiq-schema/pull/68)
- Fix issue with showback_rate belongs and type of the data in steps let INFINITY [(#67)](https://github.com/ManageIQ/manageiq-schema/pull/67)
- Skip editing /etc/fstab if it doesn't exist [(#52)](https://github.com/ManageIQ/manageiq-schema/pull/52)
- Set ActiveRecord::Migrator.migrations_paths correctly [(#51)](https://github.com/ManageIQ/manageiq-schema/pull/51)

## Unreleased as of Sprint 79 ending 2018-01-29

### Added
- Migrate Picture content from BinaryBlobs to Pictures table [(#153)](https://github.com/ManageIQ/manageiq-schema/pull/153)
- Add tables for v2v migration [(#149)](https://github.com/ManageIQ/manageiq-schema/pull/149)

### Fixed
- Handle cases where a Picture with that id doesn't exist [(#159)](https://github.com/ManageIQ/manageiq-schema/pull/159)
- Delete the dangling blob when there is a blob without a picture [(#158)](https://github.com/ManageIQ/manageiq-schema/pull/158)
- Change container_quota_items float columns to decimals [(#151)](https://github.com/ManageIQ/manageiq-schema/pull/151)
- Move Openstack refresh settings under the root where they belong [(#146)](https://github.com/ManageIQ/manageiq-schema/pull/146)

## Unreleased as of Sprint 72 ending 2017-10-30

### Added
- Rename Tables and some changes for Showback Models [(#96)](https://github.com/ManageIQ/manageiq-schema/pull/96)
- Add user_id group_id tenant_id to EventStream. [(#94)](https://github.com/ManageIQ/manageiq-schema/pull/94)
- Migrate MiddlewareServer to MiddlewareServerWildfly and MiddlewareServerEap [(#81)](https://github.com/ManageIQ/manageiq-schema/pull/81)
- Add requests and limits to Persistent Volume Claim [(#74)](https://github.com/ManageIQ/manageiq-schema/pull/74)

### Fixed
- Ensure EMS relationships are established on upgrade. [(#117)](https://github.com/ManageIQ/manageiq-schema/pull/117)
- Add an 'Allocated cpu cores' chargeback rate detail to existing chargeback rates [(#108)](https://github.com/ManageIQ/manageiq-schema/pull/108)
- Migrate EmsRefresh.refresh queue args to data [(#107)](https://github.com/ManageIQ/manageiq-schema/pull/107)
- Convert containers hawkular Endpoints port=nil to port=443 [(#98)](https://github.com/ManageIQ/manageiq-schema/pull/98)
- Add sub_metric column to chargeback_rate_detail [(#93)](https://github.com/ManageIQ/manageiq-schema/pull/93)
- Move Openstack refresher settings [(#91)](https://github.com/ManageIQ/manageiq-schema/pull/91)
- Migrate existing dialog field association data to use new relationship [(#80)](https://github.com/ManageIQ/manageiq-schema/pull/80)
- single sequence for all metrics sub tables [(#48)](https://github.com/ManageIQ/manageiq-schema/pull/48)

## Initial changelog added
