class CreateLegacyManagers < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!
  include MigrationHelper

  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled

    include MigrationStubHelper

    has_one  :swift_manager,
             -> { swift_managers },
             :foreign_key => :parent_ems_id,
             :class_name  => "CreateLegacyManagers::ExtManagementSystem",
             :autosave    => true

    has_one  :cinder_manager,
             -> { cinder_managers },
             :foreign_key => :parent_ems_id,
             :class_name  => "CreateLegacyManagers::ExtManagementSystem",
             :autosave    => true

    def self.openstack
      where(:type => "ManageIQ::Providers::Openstack::CloudManager")
    end

    def self.swift_managers
      where(:type => "ManageIQ::Providers::StorageManager::SwiftManager")
    end

    def self.cinder_managers
      where(:type => "ManageIQ::Providers::Openstack::StorageManager::CinderManager")
    end
  end

  class CloudVolume < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class CloudVolumeBackup < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class CloudVolumeSnapshot < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class CloudObjectStoreContainer < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class CloudObjectStoreObject < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    cloud_managers = ExtManagementSystem.openstack.pluck(:id)
    missing_cinder_manager = cloud_managers - ExtManagementSystem.cinder_managers.pluck(:parent_ems_id)
    missing_swift_manager = cloud_managers - ExtManagementSystem.swift_managers.pluck(:parent_ems_id)

    say_with_time("Adding missing Cinder Managers") do
      ExtManagementSystem.where(:id => missing_cinder_manager).each do |parent|
        child = parent.create_cinder_manager(
          :name            => "#{parent.name} Cinder Manager",
          :zone_id         => parent.zone_id,
          :tenant_id       => parent.tenant_id,
          :provider_region => parent.provider_region
        )

        CloudVolume.where(:ems_id => parent.id).update(:ems_id => child.id)
        CloudVolumeBackup.where(:ems_id => parent.id).update(:ems_id => child.id)
        CloudVolumeSnapshot.where(:ems_id => parent.id).update(:ems_id => child.id)
      end
    end

    say_with_time("Adding missing Swift Managers") do
      ExtManagementSystem.where(:id => missing_swift_manager).each do |parent|
        child = parent.create_swift_manager(
          :name            => "#{parent.name} Swift Manager",
          :zone_id         => parent.zone_id,
          :tenant_id       => parent.tenant_id,
          :provider_region => parent.provider_region
        )
        CloudObjectStoreContainer.where(:ems_id => parent.id).update(:ems_id => child.id)
        CloudObjectStoreObject.where(:ems_id => parent.id).update(:ems_id => child.id)
      end
    end
  end
end
