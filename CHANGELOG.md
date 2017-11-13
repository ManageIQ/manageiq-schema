# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)


## Gaprindashvili Beta1

### Added
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
- Add columns for mw domain entities in event streams table [(#86)](https://github.com/ManageIQ/manageiq-schema/pull/86)
- Rename the provisioning_manager_id column in the customization_scripts table [(#85)](https://github.com/ManageIQ/manageiq-schema/pull/85)
- Change rake spec to run all specs and be the default [(#78)](https://github.com/ManageIQ/manageiq-schema/pull/78)
- Fix migration name typo: s/shorback/showback/ [(#76)](https://github.com/ManageIQ/manageiq-schema/pull/76)
- Fix db:migrate:reset by setting DatabaseTasks.migrations_paths [(#68)](https://github.com/ManageIQ/manageiq-schema/pull/68)
- Fix issue with showback_rate belongs and type of the data in steps let INFINITY [(#67)](https://github.com/ManageIQ/manageiq-schema/pull/67)
- Skip editing /etc/fstab if it doesn't exist [(#52)](https://github.com/ManageIQ/manageiq-schema/pull/52)
- Set ActiveRecord::Migrator.migrations_paths correctly [(#51)](https://github.com/ManageIQ/manageiq-schema/pull/51)
