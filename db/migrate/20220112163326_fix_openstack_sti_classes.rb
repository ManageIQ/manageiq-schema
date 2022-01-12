class FixOpenstackStiClasses < ActiveRecord::Migration[6.0]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class CloudVolume < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixOpenstackStiClasses::ExtManagementSystem"
  end

  class CloudVolumeSnapshot < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixOpenstackStiClasses::ExtManagementSystem"
  end

  class CloudVolumeType < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixOpenstackStiClasses::ExtManagementSystem"
  end

  class CloudVolumeBackup < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixOpenstackStiClasses::ExtManagementSystem"
  end

  class CloudObjectStoreObject < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixOpenstackStiClasses::ExtManagementSystem"
  end

  class CloudObjectStoreContainer < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixOpenstackStiClasses::ExtManagementSystem"
  end

  def up
    say_with_time("Fixing Openstack Cinder/Swift STI classes") do
      cinder_klass = "ManageIQ::Providers::Openstack::StorageManager::CinderManager"
      swift_klass  = "ManageIQ::Providers::Openstack::StorageManager::SwiftManager"

      cinder_managers = ExtManagementSystem.in_my_region.where(:type => cinder_klass)
      swift_managers  = ExtManagementSystem.in_my_region.where(:type => swift_klass)

      CloudVolume.in_my_region
                 .where(:ext_management_system => cinder_managers)
                 .update_all(:type => "#{cinder_klass}::CloudVolume")
      CloudVolumeSnapshot.in_my_region
                         .where(:ext_management_system => cinder_managers)
                         .update_all(:type => "#{cinder_klass}::CloudVolumeSnapshot")
      CloudVolumeType.in_my_region
                     .where(:ext_management_system => cinder_managers)
                     .update_all(:type => "#{cinder_klass}::CloudVolumeType")
      CloudVolumeBackup.in_my_region
                       .where(:ext_management_system => cinder_managers)
                       .update_all(:type => "#{cinder_klass}::CloudVolumeBackup")

      CloudObjectStoreObject.in_my_region
                            .where(:ext_management_system => swift_managers)
                            .update_all(:type => "#{swift_klass}::CloudObjectStoreObject")
      CloudObjectStoreContainer.in_my_region
                               .where(:ext_management_system => swift_managers)
                               .update_all(:type => "#{swift_klass}::CloudObjectStoreContainer")
    end
  end

  def down
    say_with_time("Resetting Openstack Cinder/Swift STI classes") do
      cinder_klass = "ManageIQ::Providers::Openstack::StorageManager::CinderManager"
      swift_klass  = "ManageIQ::Providers::Openstack::StorageManager::SwiftManager"

      cinder_managers = ExtManagementSystem.in_my_region.where(:type => cinder_klass)
      swift_managers  = ExtManagementSystem.in_my_region.where(:type => swift_klass)

      CloudVolume.in_my_region
                 .where(:ext_management_system => cinder_managers)
                 .update_all(:type => nil)
      CloudVolumeSnapshot.in_my_region
                         .where(:ext_management_system => cinder_managers)
                         .update_all(:type => nil)
      CloudVolumeType.in_my_region
                     .where(:ext_management_system => cinder_managers)
                     .update_all(:type => nil)
      CloudVolumeBackup.in_my_region
                       .where(:ext_management_system => cinder_managers)
                       .update_all(:type => nil)

      CloudObjectStoreObject.in_my_region
                            .where(:ext_management_system => swift_managers)
                            .update_all(:type => nil)
      CloudObjectStoreContainer.in_my_region
                               .where(:ext_management_system => swift_managers)
                               .update_all(:type => nil)
    end
  end
end
