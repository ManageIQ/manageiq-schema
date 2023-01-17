class DropScvmmProvider < ActiveRecord::Migration[6.1]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class EmsCluster < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class EmsFolder < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class Host < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class MiqRequestTask < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class ResourcePool < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class Storage < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class VmOrTemplate < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
    self.table_name = "vms"
  end

  def up
    say_with_time("Deleting SCVMM Provider") do
      EmsCluster.in_my_region.where(:type => "ManageIQ::Providers::Microsoft::InfraManager::Cluster").delete_all
      EmsFolder.in_my_region.where(:type => %w[ManageIQ::Providers::Microsoft::InfraManager::Datacenter ManageIQ::Providers::Microsoft::InfraManager::Folder]).delete_all
      Host.in_my_region.where(:type => "ManageIQ::Providers::Microsoft::InfraManager::Host").delete_all
      MiqRequestTask.in_my_region.where(:type => "ManageIQ::Providers::Microsoft::InfraManager::Provision").delete_all
      ResourcePool.in_my_region.where(:type => "ManageIQ::Providers::Microsoft::InfraManager::ResourcePool").delete_all
      Storage.in_my_region.where(:type => "ManageIQ::Providers::Microsoft::InfraManager::Storage").delete_all
      VmOrTemplate.in_my_region.where(:type => %w[ManageIQ::Providers::Microsoft::InfraManager::Vm ManageIQ::Providers::Microsoft::InfraManager::Template]).delete_all
      ExtManagementSystem.in_my_region.where(:type => "ManageIQ::Providers::Microsoft::InfraManager").delete_all
    end
  end
end
