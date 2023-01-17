require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe DropScvmmProvider do
  let(:ext_management_system_stub) { migration_stub(:ExtManagementSystem) }
  let(:ems_cluster_stub) { migration_stub(:EmsCluster) }
  let(:ems_folder_stub) { migration_stub(:EmsFolder) }
  let(:host_stub) { migration_stub(:Host) }
  let(:miq_request_task_stub) { migration_stub(:MiqRequestTask) }
  let(:resource_pool_stub) { migration_stub(:ResourcePool) }
  let(:storage_stub) { migration_stub(:Storage) }
  let(:vm_or_template_stub) { migration_stub(:VmOrTemplate) }

  migration_context :up do
    it "deletes SCVMM records" do
      ems        = ext_management_system_stub.create!(:type => "ManageIQ::Providers::Microsoft::InfraManager")
      cluster    = ems_cluster_stub.create!(:type => "ManageIQ::Providers::Microsoft::InfraManager::Cluster", :ems_id => ems.id)
      datacenter = ems_folder_stub.create!(:type => "ManageIQ::Providers::Microsoft::InfraManager::Datacenter", :ems_id => ems.id)
      folder     = ems_folder_stub.create!(:type => "ManageIQ::Providers::Microsoft::InfraManager::Folder", :ems_id => ems.id)
      host       = host_stub.create!(:type => "ManageIQ::Providers::Microsoft::InfraManager::Host", :ems_id => ems.id)
      provision  = miq_request_task_stub.create!(:type => "ManageIQ::Providers::Microsoft::InfraManager::Provision")
      respool    = resource_pool_stub.create!(:type => "ManageIQ::Providers::Microsoft::InfraManager::ResourcePool", :ems_id => ems.id)
      storage    = storage_stub.create!(:type => "ManageIQ::Providers::Microsoft::InfraManager::Storage", :ems_id => ems.id)
      vm         = vm_or_template_stub.create!(:type => "ManageIQ::Providers::Microsoft::InfraManager::Vm", :ems_id => ems.id)
      template   = vm_or_template_stub.create!(:type => "ManageIQ::Providers::Microsoft::InfraManager::Template", :ems_id => ems.id)

      migrate

      expect { ems.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { cluster.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { datacenter.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { folder.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { host.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { provision.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { respool.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { storage.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { vm.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { template.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "doesn't impact unassociated inventory" do
      ems        = ext_management_system_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager")
      cluster    = ems_cluster_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager::Cluster", :ems_id => ems.id)
      datacenter = ems_folder_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager::Datacenter", :ems_id => ems.id)
      folder     = ems_folder_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager::Folder", :ems_id => ems.id)
      host       = host_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager::Host", :ems_id => ems.id)
      provision  = miq_request_task_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager::Provision")
      respool    = resource_pool_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager::ResourcePool", :ems_id => ems.id)
      storage    = storage_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager::Storage", :ems_id => ems.id)
      vm         = vm_or_template_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager::Vm", :ems_id => ems.id)
      template   = vm_or_template_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager::Template", :ems_id => ems.id)

      migrate

      expect { ems.reload }.not_to raise_error
      expect { cluster.reload }.not_to raise_error
      expect { datacenter.reload }.not_to raise_error
      expect { folder.reload }.not_to raise_error
      expect { host.reload }.not_to raise_error
      expect { provision.reload }.not_to raise_error
      expect { respool.reload }.not_to raise_error
      expect { storage.reload }.not_to raise_error
      expect { vm.reload }.not_to raise_error
      expect { template.reload }.not_to raise_error
    end
  end
end
