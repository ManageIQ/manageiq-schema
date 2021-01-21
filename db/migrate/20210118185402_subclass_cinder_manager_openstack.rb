class SubclassCinderManagerOpenstack < ActiveRecord::Migration[6.0]
  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Subclass CinderManager under Openstack") do
      ExtManagementSystem.where(:type => "ManageIQ::Providers::StorageManager::CinderManager")
                         .update_all(:type => "ManageIQ::Providers::Openstack::StorageManager::CinderManager")
    end
  end
end
