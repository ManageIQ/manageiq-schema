class FixOracleCloudStiClasses < ActiveRecord::Migration[6.0]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class CloudTenant < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixOracleCloudStiClasses::ExtManagementSystem"
  end

  class LoadBalancer < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixOracleCloudStiClasses::ExtManagementSystem"
  end

  def up
    say_with_time("Fixing Oracle Cloud STI classes") do
      cloud_managers = ExtManagementSystem.in_my_region.where(:type => "ManageIQ::Providers::OracleCloud::CloudManager")
      CloudTenant.in_my_region.where(:ext_management_system => cloud_managers).update_all(:type => "ManageIQ::Providers::OracleCloud::CloudManager::CloudTenant")

      network_managers = ExtManagementSystem.in_my_region.where(:type => "ManageIQ::Providers::OracleCloud::NetworkManager")
      LoadBalancer.in_my_region.where(:ext_management_system => network_managers).update_all(:type => "ManageIQ::Providers::OracleCloud::NetworkManager::LoadBalancer")
    end
  end

  def down
    say_with_time("Resetting Oracle Cloud STI classes") do
      cloud_managers = ExtManagementSystem.in_my_region.where(:type => "ManageIQ::Providers::OracleCloud::CloudManager")
      CloudTenant.in_my_region.where(:ext_management_system => cloud_managers).update_all(:type => nil)

      network_managers = ExtManagementSystem.in_my_region.where(:type => "ManageIQ::Providers::OracleCloud::NetworkManager")
      LoadBalancer.in_my_region.where(:ext_management_system => network_managers).update_all(:type => nil)
    end
  end
end
