class SubclassEmsFolders < ActiveRecord::Migration[5.1]
  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class EmsFolder < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "SubclassEmsFolders::ExtManagementSystem"
  end

  def up
    %w[Microsoft Redhat Vmware].each do |provider|
      ems_class_name = "ManageIQ::Providers::#{provider}::InfraManager"

      folder_class_name = "#{ems_class_name}::Folder"
      EmsFolder.in_my_region
               .joins(:ext_management_system)
               .where(:ext_management_systems => {:type => ems_class_name}, :type => nil)
               .update_all(:type => folder_class_name)

      datacenter_class_name = "#{ems_class_name}::Datacenter"
      EmsFolder.in_my_region
               .joins(:ext_management_system)
               .where(:ext_management_systems => {:type => ems_class_name}, :type => "Datacenter")
               .update_all(:type => datacenter_class_name)

      storage_cluster_class_name = "#{ems_class_name}::StorageCluster"
      EmsFolder.in_my_region
               .joins(:ext_management_system)
               .where(:ext_management_systems => {:type => ems_class_name}, :type => "StorageCluster")
               .update_all(:type => storage_cluster_class_name)
    end
  end

  def down
    provider_folder_types = %w[Microsoft Redhat Vmware].map do |provider|
      "ManageIQ::Providers::#{provider}::InfraManager::Folder"
    end

    provider_datacenter_types = %w[Microsoft Redhat Vmware].map do |provider|
      "ManageIQ::Providers::#{provider}::InfraManager::Datacenter"
    end

    provider_storage_cluster_types = %w[Microsoft Redhat Vmware].map do |provider|
      "ManageIQ::Providers::#{provider}::InfraManager::StorageCluster"
    end

    EmsFolder.in_my_region.where(:type => provider_folder_types).update_all(:type => nil)
    EmsFolder.in_my_region.where(:type => provider_datacenter_types).update_all(:type => "Datacenter")
    EmsFolder.in_my_region.where(:type => provider_storage_cluster_types).update_all(:type => "StorageCluster")
  end
end
