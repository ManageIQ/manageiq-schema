class SubclassSwiftManagerOpenstack < ActiveRecord::Migration[5.2]
  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Subclass SwiftManager under Openstack") do
      ExtManagementSystem.where(:type => "ManageIQ::Providers::StorageManager::SwiftManager")
                         .update_all(:type => "ManageIQ::Providers::Openstack::StorageManager::SwiftManager")
    end
  end

  def down
    say_with_time("Move SwiftManager from Openstack") do
      ExtManagementSystem.where(:type => "ManageIQ::Providers::Openstack::StorageManager::SwiftManager")
                         .update_all(:type => "ManageIQ::Providers::StorageManager::SwiftManager")
    end
  end
end
