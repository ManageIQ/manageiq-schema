require_migration

describe UpdateVmwareFolderTypes do
  let(:folder_stub) { migration_stub(:EmsFolder) }
  let(:ems_stub)    { migration_stub(:ExtManagementSystem) }

  migration_context :up do
    it "sets type for Vmware folders" do
      ems_vmware = ems_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager")
      ems_redhat = ems_stub.create!(:type => "ManageIQ::Providers::Redhat::InfraManager")

      folder_vmware = folder_stub.create!(:name => "Vmware folder", :ems_id => ems_vmware.id)
      dc_vmware     = folder_stub.create!(:name => "Default", :ems_id => ems_vmware.id, :type => "Datacenter")
      dc_other      = folder_stub.create!(:name => "Default", :ems_id => ems_redhat.id, :type => "Datacenter")
      folder_redhat = folder_stub.create!(:name => "Redhat folder", :ems_id => ems_redhat.id)
      folder_other  = folder_stub.create!(:name => "Default Inventory", :ems_id => ems_redhat.id, :type => "ManageIQ::Providers::AutomationManager::InventoryRootGroup")

      migrate

      expect(folder_vmware.reload.type).to eq("ManageIQ::Providers::Vmware::InfraManager::Folder")
      expect(dc_vmware.reload.type).to eq("ManageIQ::Providers::Vmware::InfraManager::Datacenter")
      expect(dc_other.reload.type).to eq("Datacenter")
      expect(folder_redhat.reload.type).to be_nil
      expect(folder_other.reload.type).to eq("ManageIQ::Providers::AutomationManager::InventoryRootGroup")
    end
  end

  migration_context :down do
    it "clears type for VMware folders" do
      folder_vmware = folder_stub.create!(:name => "Vmware folder", :type => "ManageIQ::Providers::Vmware::InfraManager::Folder")
      dc_vmware     = folder_stub.create!(:name => "Default", :type => "ManageIQ::Providers::Vmware::InfraManager::Datacenter")
      dc_other      = folder_stub.create!(:name => "Default", :type => "Datacenter")
      folder_redhat = folder_stub.create!(:name => "Redhat folder")
      folder_other  = folder_stub.create!(:name => "Default Inventory", :type => "ManageIQ::Providers::AutomationManager::InventoryRootGroup")

      migrate

      expect(folder_vmware.reload.type).to be_nil
      expect(dc_vmware.reload.type).to eq("Datacenter")
      expect(dc_other.reload.type).to eq("Datacenter")
      expect(folder_redhat.reload.type).to be_nil
      expect(folder_other.reload.type).to eq("ManageIQ::Providers::AutomationManager::InventoryRootGroup")
    end
  end
end
