class AddCpuCoresColumnsToResourcePools < ActiveRecord::Migration[6.0]
  class ResourcePool < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  def up
    add_column :resource_pools, :cpu_cores_available, :float
    add_column :resource_pools, :cpu_cores_reserve, :float
    add_column :resource_pools, :cpu_cores_limit, :float

    say_with_time('Removing non-applicable data from IbmCloud::PowerVirtualServer resource pools') do
      ResourcePool.in_my_region.where(:type => %w[ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::ResourcePool]).update_all(
        :cpu_shares  => nil,
        :cpu_reserve => nil,
        :cpu_limit   => nil
      )
    end

    say_with_time('Removing non-applicable data from IbmPowerHmc resource pools') do
      ResourcePool.in_my_region.where(:type => %w[ManageIQ::Providers::IbmPowerHmc::InfraManager::ProcessorResourcePool]).update_all(
        :cpu_shares  => nil,
        :cpu_reserve => nil,
        :cpu_limit   => nil
      )
    end
  end

  def down
    remove_column :resource_pools, :cpu_cores_available
    remove_column :resource_pools, :cpu_cores_reserve
    remove_column :resource_pools, :cpu_cores_limit
  end
end
