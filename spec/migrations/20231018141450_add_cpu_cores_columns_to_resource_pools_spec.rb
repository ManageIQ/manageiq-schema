require_migration

describe AddCpuCoresColumnsToResourcePools do
  let(:resource_pools_stub) { migration_stub(:ResourcePool) }

  migration_context :up do
    it "Removes non-applicable data only from Power resource pools" do
      ibm_cloud_power_vs_resource_pool = resource_pools_stub.create(
        :type               => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::ResourcePool",
        :cpu_shares         => 1,
        :cpu_reserve        => 2,
        :cpu_limit          => 3,
        :cpu_reserve_expand => true,
        :is_default         => false
      )

      ibm_power_hmc_processor_resource_pool = resource_pools_stub.create(
        :type               => "ManageIQ::Providers::IbmPowerHmc::InfraManager::ProcessorResourcePool",
        :cpu_shares         => 1,
        :cpu_reserve        => 2,
        :cpu_limit          => -1,
        :cpu_reserve_expand => true,
        :is_default         => false
      )

      migrate

      expect(ibm_cloud_power_vs_resource_pool.reload).to have_attributes(
        :cpu_shares         => nil,
        :cpu_reserve        => nil,
        :cpu_limit          => nil,
        :cpu_reserve_expand => true,
        :is_default         => false
      )

      expect(ibm_power_hmc_processor_resource_pool.reload).to have_attributes(
        :cpu_shares         => nil,
        :cpu_reserve        => nil,
        :cpu_limit          => nil,
        :cpu_reserve_expand => true,
        :is_default         => false
      )
    end

    it "Does not change non-Power resource pools" do
      vmware_resource_pool = resource_pools_stub.create(
        :type               => "ManageIQ::Providers::Vmware::InfraManager::ResourcePool",
        :cpu_shares         => 1,
        :cpu_reserve        => 2,
        :cpu_limit          => 3,
        :cpu_reserve_expand => true,
        :is_default         => false
      )

      migrate

      expect(vmware_resource_pool).to have_attributes(
        :type               => "ManageIQ::Providers::Vmware::InfraManager::ResourcePool",
        :cpu_shares         => 1,
        :cpu_reserve        => 2,
        :cpu_limit          => 3,  # rand(-1..65536) ?
        :cpu_reserve_expand => true,
        :is_default         => false
      )
    end
  end

  migration_context :down do
    it "Does not change non-Power resource pools" do
      vmware_resource_pool = resource_pools_stub.create(
        :type               => "ManageIQ::Providers::Vmware::InfraManager::ResourcePool",
        :cpu_shares         => 1,
        :cpu_reserve        => 2,
        :cpu_limit          => 3,
        :cpu_reserve_expand => true,
        :is_default         => false
      )

      migrate

      expect(vmware_resource_pool).to have_attributes(
        :type               => "ManageIQ::Providers::Vmware::InfraManager::ResourcePool",
        :cpu_shares         => 1,
        :cpu_reserve        => 2,
        :cpu_limit          => 3,  # rand(-1..65536) ?
        :cpu_reserve_expand => true,
        :is_default         => false
      )
    end
  end
end
