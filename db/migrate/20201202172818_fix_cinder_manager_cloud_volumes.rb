class FixCinderManagerCloudVolumes < ActiveRecord::Migration[5.2]
  class CloudVolume < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class CloudVolumeBackup < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class CloudVolumeSnapshot < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class CloudVolumeType < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  def up
    [CloudVolume, CloudVolumeBackup, CloudVolumeSnapshot, CloudVolumeType].each do |klass|
      klass_name = klass.name.sub("FixCinderManagerCloudVolumes::", "")

      old_type = "#{openstack_klass}::#{klass_name}"
      new_type = "#{cinder_klass}::#{klass_name}"

      say_with_time("Fixing OpenStack #{klass_name} STI class") do
        klass.in_my_region.where(:type => old_type).update_all(:type => new_type)
      end
    end
  end

  def down
    [CloudVolume, CloudVolumeBackup, CloudVolumeSnapshot, CloudVolumeType].each do |klass|
      klass_name = klass.name.sub("FixCinderManagerCloudVolumes::", "")

      old_type = "#{cinder_klass}::#{klass_name}"
      new_type = "#{openstack_klass}::#{klass_name}"

      say_with_time("Resetting OpenStack #{klass_name} STI class") do
        klass.in_my_region.where(:type => old_type).update_all(:type => new_type)
      end
    end
  end

  private

  def cinder_klass
    "ManageIQ::Providers::Openstack::StorageManager::CinderManager".freeze
  end

  def openstack_klass
    "ManageIQ::Providers::Openstack::CloudManager".freeze
  end
end
