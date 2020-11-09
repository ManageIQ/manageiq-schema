class FixOpenstackCloudVolumeStiTypes < ActiveRecord::Migration[5.2]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class CloudVolume < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system,
               :foreign_key => :ems_id,
               :class_name  => "FixOpenstackCloudVolumeStiTypes::ExtManagementSystem"
  end

  class CloudVolumeBackup < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system,
               :foreign_key => :ems_id,
               :class_name  => "FixOpenstackCloudVolumeStiTypes::ExtManagementSystem"
  end

  class CloudVolumeSnapshot < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system,
               :foreign_key => :ems_id,
               :class_name  => "FixOpenstackCloudVolumeStiTypes::ExtManagementSystem"
  end

  class CloudVolumeType < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system,
               :foreign_key => :ems_id,
               :class_name  => "FixOpenstackCloudVolumeStiTypes::ExtManagementSystem"
  end

  def up
    [CloudVolume, CloudVolumeBackup, CloudVolumeSnapshot, CloudVolumeType].each do |klass|
      klass_name = klass.name.sub("FixOpenstackCloudVolumeStiTypes::", "")

      old_type = "#{openstack_klass}::#{klass_name}"
      new_type = "#{cinder_klass}::#{klass_name}"

      say_with_time("Fixing OpenStack #{klass_name} STI class") do
        klass.in_my_region
             .where(:ext_management_system => cinder_managers, :type => old_type)
             .update_all(:type => new_type)
      end
    end
  end

  def down
    [CloudVolume, CloudVolumeBackup, CloudVolumeSnapshot, CloudVolumeType].each do |klass|
      klass_name = klass.name.sub("FixOpenstackCloudVolumeStiTypes::", "")

      old_type = "#{cinder_klass}::#{klass_name}"
      new_type = "#{openstack_klass}::#{klass_name}"

      say_with_time("Resetting OpenStack #{klass_name} STI class") do
        klass.in_my_region
             .where(:ext_management_system => cinder_managers, :type => old_type)
             .update_all(:type => new_type)
      end
    end
  end

  private

  def cinder_managers
    ExtManagementSystem.in_my_region.where(:type => cinder_klass)
  end

  def cinder_klass
    "ManageIQ::Providers::Openstack::StorageManager::CinderManager".freeze
  end

  def openstack_klass
    "ManageIQ::Providers::Openstack::CloudManager".freeze
  end
end
