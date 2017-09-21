# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)


## Unreleased as of Sprint 69 ending 2017-09-18

### Added
- Chargeback
  - Models for tiers in showback [(#66)](https://github.com/ManageIQ/manageiq-schema/pull/66)
- Schema
  - Add serial_number to hardware [(#63)](https://github.com/ManageIQ/manageiq-schema/pull/63)
  - Add schema support for LXCA config patterns [(#61)](https://github.com/ManageIQ/manageiq-schema/pull/61)
  - Add container_project_id to persistent_volume_claims [(#60)](https://github.com/ManageIQ/manageiq-schema/pull/60)
  - Add object_labels to Container Template [(#32)](https://github.com/ManageIQ/manageiq-schema/pull/32)

### Fixed
- Chargeback
  - Fix issue with showback_rate belongs and type of the data in steps let INFINITY [(#67)](https://github.com/ManageIQ/manageiq-schema/pull/67)

## Unreleased as of Sprint 68 ending 2017-09-04

### Added
- Automate
  - Added AutomateWorkspace which can be retrieved using REST API [(#50)](https://github.com/ManageIQ/manageiq-schema/pull/50)
  - Add hash_expression to MiqAlert [(#49)](https://github.com/ManageIQ/manageiq-schema/pull/49)

- Platform
  - Migrate the roles that we live migrate at startup [(#58)](https://github.com/ManageIQ/manageiq-schema/pull/58)

### Fixed
- Platform
  - Skip editing /etc/fstab if it doesn't exist [(#52)](https://github.com/ManageIQ/manageiq-schema/pull/52)
  - Set ActiveRecord::Migrator.migrations_paths correctly [(#51)](https://github.com/ManageIQ/manageiq-schema/pull/51)

## Unreleased as of Sprint 66 ending 2017-08-07

### Added
- Platform
  - Add expression to entitlements [(#47)](https://github.com/ManageIQ/manageiq-schema/pull/47)
  - Add Resource to OpenSCAP results [(#42)](https://github.com/ManageIQ/manageiq-schema/pull/42)
- UI (Classic)
  - Add DialogFieldAssociation table [(#41)](https://github.com/ManageIQ/manageiq-schema/pull/41)
  - Custom fonticons and colors in the CustomButton(Set) model [(#39)](https://github.com/ManageIQ/manageiq-schema/pull/39)
  - Add type to ContainerTemplate to allow subclassing. [(#35)](https://github.com/ManageIQ/manageiq-schema/pull/35)
  - Migrations for merging container_definition and container [(#24)](https://github.com/ManageIQ/manageiq-schema/pull/24)
  - Add options to ems [(#23)](https://github.com/ManageIQ/manageiq-schema/pull/23)
