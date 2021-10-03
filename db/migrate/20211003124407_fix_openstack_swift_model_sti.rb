class FixOpenstackSwiftModelSti < ActiveRecord::Migration[6.0]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class CloudObjectStoreContainer < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixOpenstackSwiftModelSti::ExtManagementSystem"
  end

  class CloudObjectStoreObject < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixOpenstackSwiftModelSti::ExtManagementSystem"
  end

  def up
    say_with_time("Fixing OpenStack Swift CloudObjectStore STI class") do
      openstack_swift_managers = ExtManagementSystem.in_my_region.where(:type => "ManageIQ::Providers::Openstack::StorageManager::SwiftManager")
      CloudObjectStoreContainer.in_my_region
                               .where(:ext_management_system => openstack_swift_managers)
                               .update_all(:type => "ManageIQ::Providers::Openstack::StorageManager::SwiftManager::CloudObjectStoreContainer")
      CloudObjectStoreObject.in_my_region
                             .where(:ext_management_system => openstack_swift_managers)
                             .update_all(:type => "ManageIQ::Providers::Openstack::StorageManager::SwiftManager::CloudObjectStoreObject")
    end
  end

  def down
    say_with_time("Resetting OpenStack Swift CloudObjectStore STI class") do
      CloudObjectStoreContainer.in_my_region
                               .where(:type => "ManageIQ::Providers::Openstack::StorageManager::SwiftManager::CloudObjectStoreContainer")
                               .update_all(:type => nil)
      CloudObjectStoreObject.in_my_region
                             .where(:type => "ManageIQ::Providers::Openstack::StorageManager::SwiftManager::CloudObjectStoreObject")
                             .update_all(:type => nil)
    end
  end
end
