require_migration

describe SubclassResourcePools do
  let(:ext_management_system_stub) { migration_stub(:ExtManagementSystem) }
  let(:resource_pool_stub)         { migration_stub(:ResourcePool) }

  migration_context :up do
    it "migrates resource pools from all supported providers" do
      emss = %w[Microsoft Redhat Vmware].map do |vendor|
        ext_management_system_stub.create!(:type => "ManageIQ::Providers::#{vendor}::InfraManager")
      end

      resource_pools = emss.map do |ems|
        resource_pool_stub.create!(:ext_management_system => ems)
      end

      migrate

      resource_pools.each do |respool|
        expect(respool.reload.type).to eq("#{respool.ext_management_system.type}::ResourcePool")
      end
    end

    it "doesn't migrate resource pools from other providers" do
      ems = ext_management_system_stub.create!(:type => "ManageIQ::Providers::AnotherManager::InfraManager")
      respool = resource_pool_stub.create!(:ext_management_system => ems)

      migrate

      expect(respool.reload.type).to be_nil
    end
  end

  migration_context :down do
    it "migrates resource pools from all supported providers" do
      emss = %w[Microsoft Redhat Vmware].map do |vendor|
        ext_management_system_stub.create!(:type => "ManageIQ::Providers::#{vendor}::InfraManager")
      end

      resource_pools = emss.map do |ems|
        resource_pool_stub.create!(:ext_management_system => ems, :type => "#{ems.type}::ResourcePool")
      end

      migrate

      resource_pools.each do |respool|
        expect(respool.reload.type).to be_nil
      end
    end

    it "doesn't migrate resource pools from other providers" do
      ems = ext_management_system_stub.create!(:type => "ManageIQ::Providers::AnotherManager::InfraManager")
      respool = resource_pool_stub.create!(:ext_management_system => ems)

      migrate

      expect(respool.reload.type).to be_nil
    end
  end
end
