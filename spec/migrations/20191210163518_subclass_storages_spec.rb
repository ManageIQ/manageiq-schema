require_migration

describe SubclassStorages do
  let(:ext_management_system_stub) { migration_stub(:ExtManagementSystem) }
  let(:storage_stub)               { migration_stub(:Storage) }

  migration_context :up do
    it "migrates storages from all supported providers" do
      emss = %w[Microsoft Redhat Vmware].map do |vendor|
        ext_management_system_stub.create!(:type => "ManageIQ::Providers::#{vendor}::InfraManager")
      end

      storages = emss.map do |ems|
        storage_stub.create!(:ext_management_system => ems)
      end

      migrate

      storages.each do |storage|
        expect(storage.reload.type).to eq("#{storage.ext_management_system.type}::Storage")
      end
    end

    it "doesn't migrate storages from other providers" do
      ems = ext_management_system_stub.create!(:type => "ManageIQ::Providers::AnotherManager::InfraManager")
      storage = storage_stub.create!(:ext_management_system => ems)

      migrate

      expect(storage.reload.type).to be_nil
    end
  end

  migration_context :down do
    it "migrates storages from all supported providers" do
      emss = %w[Microsoft Redhat Vmware].map do |vendor|
        ext_management_system_stub.create!(:type => "ManageIQ::Providers::#{vendor}::InfraManager")
      end

      storages = emss.map do |ems|
        storage_stub.create!(:ext_management_system => ems, :type => "#{ems.type}::Storage")
      end

      migrate

      storages.each do |storage|
        expect(storage.reload.type).to be_nil
      end
    end

    it "doesn't migrate storages from other providers" do
      ems = ext_management_system_stub.create!(:type => "ManageIQ::Providers::AnotherManager::InfraManager")
      storage = storage_stub.create!(:ext_management_system => ems)

      migrate

      expect(storage.reload.type).to be_nil
    end
  end
end
