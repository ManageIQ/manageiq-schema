class FixVmwareInfraEndpoint < ActiveRecord::Migration[6.0]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class Endpoint < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  VMWARE_INFRA_MANAGER = "ManageIQ::Providers::Vmware::InfraManager".freeze

  def up
    say_with_time("Updating VMware endpoint port and verify_ssl") do
      vmware_infra_managers    = ExtManagementSystem.in_my_region.where(:type => VMWARE_INFRA_MANAGER).pluck(:id)
      vmware_default_endpoints = Endpoint.in_my_region.where(
        :role          => "default",
        :resource_type => "ExtManagementSystem",
        :resource_id   => vmware_infra_managers
      )

      vmware_default_endpoints.update_all(:verify_ssl => 0)
      vmware_default_endpoints.where(:port => nil).update_all(:port => 443)
    end
  end

  def down
    say_with_time("Updating VMware endpoint port and verify_ssl") do
      vmware_infra_managers    = ExtManagementSystem.in_my_region.where(:type => VMWARE_INFRA_MANAGER).pluck(:id)
      vmware_default_endpoints = Endpoint.in_my_region.where(
        :role          => "default",
        :resource_type => "ExtManagementSystem",
        :resource_id   => vmware_infra_managers
      )
      vmware_default_endpoints.update_all(:port => nil, :verify_ssl => 1)
    end
  end
end
