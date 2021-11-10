class SetVpcAvailabilityZonesSti < ActiveRecord::Migration[6.0]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class AvailabilityZone < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "SetVpcAvailabilityZonesSti::ExtManagementSystem"
  end

  def up
    say_with_time("Fixing IBM Cloud VPC AvailabilityZone STI class") do
      vpc_cloud_managers = ExtManagementSystem.in_my_region.where(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager")
      AvailabilityZone.in_my_region
                      .where(:ext_management_system => vpc_cloud_managers)
                      .update_all(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager::AvailabilityZone")
    end
  end

  def down
    say_with_time("Resetting IBM Cloud VPC AvailabilityZone STI class") do
      AvailabilityZone.in_my_region
                      .where(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager::AvailabilityZone")
                      .update_all(:type => nil)
    end
  end
end
