class FixPowerVcCloudTenantSti < ActiveRecord::Migration[6.0]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class CloudTenant < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixPowerVcCloudTenantSti::ExtManagementSystem"
  end

  def up
    say_with_time("Fixing PowerVC CloudTenant STI class") do
      power_vc_managers = ExtManagementSystem.in_my_region.where(:type => "ManageIQ::Providers::IbmPowerVc::CloudManager")
      CloudTenant.in_my_region
                 .where(:ext_management_system => power_vc_managers)
                 .update_all(:type => "ManageIQ::Providers::IbmPowerVc::CloudManager::CloudTenant")
    end
  end

  def down
    say_with_time("Reset PowerVC CloudTenant STI class") do
      power_vc_managers = ExtManagementSystem.in_my_region.where(:type => "ManageIQ::Providers::IbmPowerVc::CloudManager")
      CloudTenant.in_my_region
                 .where(:ext_management_system => power_vc_managers)
                 .update_all(:type => "ManageIQ::Providers::Openstack::CloudManager::CloudTenant")
    end
  end
end
