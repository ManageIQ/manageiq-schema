require_migration

describe SubclassEmsFolders do
  let(:ext_management_system_stub) { migration_stub(:ExtManagementSystem) }
  let(:ems_folder_stub)            { migration_stub(:EmsFolder) }

  migration_context :up do
    it "migrates folders and datacenters from all supported providers" do
      emss = %w[Microsoft Redhat Vmware].map do |vendor|
        ext_management_system_stub.create!(:type => "ManageIQ::Providers::#{vendor}::InfraManager")
      end

      folders          = emss.map { |ems| ems_folder_stub.create!(:ext_management_system => ems) }
      datacenters      = emss.map { |ems| ems_folder_stub.create!(:ext_management_system => ems, :type => "Datacenter") }
      storage_clusters = emss.map { |ems| ems_folder_stub.create!(:ext_management_system => ems, :type => "StorageCluster") }

      migrate

      folders.each          { |folder| expect(folder.reload.type).to eq("#{folder.ext_management_system.type}::Folder") }
      datacenters.each      { |dc| expect(dc.reload.type).to eq("#{dc.ext_management_system.type}::Datacenter") }
      storage_clusters.each { |sc| expect(sc.reload.type).to eq("#{sc.ext_management_system.type}::StorageCluster") }
    end

    it "doesn't migrate an unrelated folder" do
      ems = ext_management_system_stub.create!(:type => "ManageIQ::Providers::AutomationManager")
      inventory_group = ems_folder_stub.create!(
        :ext_management_system => ems,
        :type                  => "ManageIQ::Providers::AutomationManager::InventoryGroup"
      )

      migrate

      expect(inventory_group.reload.type).to eq("ManageIQ::Providers::AutomationManager::InventoryGroup")
    end
  end

  migration_context :down do
    it "migrates folders and datacenters from all supported providers" do
      emss = %w[Microsoft Redhat Vmware].map do |vendor|
        ext_management_system_stub.create!(:type => "ManageIQ::Providers::#{vendor}::InfraManager")
      end

      folders = emss.map do |ems|
        ems_folder_stub.create!(:ext_management_system => ems, :type => "#{ems.type}::Folder")
      end
      datacenters = emss.map do |ems|
        ems_folder_stub.create!(:ext_management_system => ems, :type => "#{ems.type}::Datacenter")
      end

      migrate

      folders.each     { |folder| expect(folder.reload.type).to be_nil }
      datacenters.each { |dc| expect(dc.reload.type).to eq("Datacenter") }
    end

    it "doesn't migrate an unrelated folder" do
      ems = ext_management_system_stub.create!(:type => "ManageIQ::Providers::AutomationManager")
      inventory_group = ems_folder_stub.create!(
        :ext_management_system => ems,
        :type                  => "ManageIQ::Providers::AutomationManager::InventoryGroup"
      )

      migrate

      expect(inventory_group.reload.type).to eq("ManageIQ::Providers::AutomationManager::InventoryGroup")
    end
  end
end
