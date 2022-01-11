class FixIbmCloudStiClasses < ActiveRecord::Migration[6.0]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class AvailabilityZone < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixIbmCloudStiClasses::ExtManagementSystem"
  end

  class Flavor < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixIbmCloudStiClasses::ExtManagementSystem"
  end

  class LoadBalancer < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixIbmCloudStiClasses::ExtManagementSystem"
  end

  class NetworkPort < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixIbmCloudStiClasses::ExtManagementSystem"
  end

  class CloudObjectStoreContainer < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixIbmCloudStiClasses::ExtManagementSystem"
  end

  class CloudObjectStoreObject < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixIbmCloudStiClasses::ExtManagementSystem"
  end

  def up
    say_with_time("Fixing IBM Cloud STI classes") do
      power_cloud = ExtManagementSystem.in_my_region.where(:type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager")
      AvailabilityZone.in_my_region.where(:ext_management_system => power_cloud).update_all(:type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::AvailabilityZone")
      Flavor.in_my_region.where(:ext_management_system => power_cloud).update_all(:type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Flavor")

      power_network = ExtManagementSystem.in_my_region.where(:type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::NetworkManager")
      LoadBalancer.in_my_region.where(:ext_management_system => power_network).update_all(:type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::NetworkManager::LoadBalancer")

      object_storage = ExtManagementSystem.in_my_region.where(:type => "ManageIQ::Providers::IbmCloud::ObjectStorage::StorageManager")
      CloudObjectStoreObject.in_my_region.where(:ext_management_system => object_storage).update_all(:type => "ManageIQ::Providers::IbmCloud::ObjectStorage::StorageManager::CloudObjectStoreObject")
      CloudObjectStoreContainer.in_my_region.where(:ext_management_system => object_storage).update_all(:type => "ManageIQ::Providers::IbmCloud::ObjectStorage::StorageManager::CloudObjectStoreContainer")

      vpc_network = ExtManagementSystem.in_my_region.where(:type => "ManageIQ::Providers::IbmCloud::VPC::NetworkManager")
      NetworkPort.in_my_region.where(:ext_management_system => vpc_network).update_all(:type => "ManageIQ::Providers::IbmCloud::VPC::NetworkManager::NetworkPort")
    end
  end

  def down
    say_with_time("Resetting IBM Cloud STI classes") do
      power_cloud = ExtManagementSystem.in_my_region.where(:type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager")
      AvailabilityZone.in_my_region.where(:ext_management_system => power_cloud).update_all(:type => nil)
      Flavor.in_my_region.where(:ext_management_system => power_cloud).update_all(:type => nil)

      power_network = ExtManagementSystem.in_my_region.where(:type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::NetworkManager")
      LoadBalancer.in_my_region.where(:ext_management_system => power_network).update_all(:type => nil)

      object_storage = ExtManagementSystem.in_my_region.where(:type => "ManageIQ::Providers::IbmCloud::ObjectStorage::StorageManager")
      CloudObjectStoreObject.in_my_region.where(:ext_management_system => object_storage).update_all(:type => nil)
      CloudObjectStoreContainer.in_my_region.where(:ext_management_system => object_storage).update_all(:type => nil)

      vpc_network = ExtManagementSystem.in_my_region.where(:type => "ManageIQ::Providers::IbmCloud::VPC::NetworkManager")
      NetworkPort.in_my_region.where(:ext_management_system => vpc_network).update_all(:type => nil)
    end
  end
end
