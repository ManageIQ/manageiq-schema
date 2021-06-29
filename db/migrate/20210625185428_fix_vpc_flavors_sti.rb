class FixVpcFlavorsSti < ActiveRecord::Migration[6.0]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class Flavor < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixVpcFlavorsSti::ExtManagementSystem"
  end

  def up
    say_with_time("Fixing IBM Cloud VPC Flavors STI class") do
      vpc_cloud_managers = ExtManagementSystem.in_my_region.where(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager")
      Flavor.in_my_region
            .where(:ext_management_system => vpc_cloud_managers)
            .update_all(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager::Flavor")
    end
  end

  def down
    say_with_time("Resetting IBM Cloud VPC Flavors STI class") do
      Flavor.in_my_region
            .where(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager::Flavor")
            .update_all(:type => nil)
    end
  end
end
