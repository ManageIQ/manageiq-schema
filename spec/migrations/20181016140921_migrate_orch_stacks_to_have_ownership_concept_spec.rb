require_migration

describe MigrateOrchStacksToHaveOwnershipConcept do
  let(:orchestration_stack) { migration_stub(:OrchestrationStack) }
  let(:ems) { migration_stub(:ExtManagementSystem) }
  let(:service) { migration_stub(:Service) }
  let(:tenant) { migration_stub(:Tenant).create! }
  let(:group) { migration_stub(:MiqGroup).create!(:tenant => tenant) }
  let!(:user) { migration_stub(:User).create!(:userid => "admin", :miq_groups => [group], :current_group => group) }

  migration_context :up do
    it "sets owner, tenant, and group from the user if neither the ems and service exist" do
      stack = orchestration_stack.create!(:ext_management_system => nil)
      expect(orchestration_stack.count).to eq(1)

      migrate
      stack.reload

      expect(stack).to have_attributes(:tenant_id => user.current_tenant.id, :evm_owner_id => user.id, :miq_group_id => user.current_group.id)
    end

    it "sets owner, tenant, and group from the ems if the ems exists and the service doesn't" do
      ext_ms = ems.create!(:tenant => tenant)
      stack = orchestration_stack.create!(:ext_management_system => ext_ms)
      expect(orchestration_stack.count).to eq(1)

      migrate
      stack.reload

      expect(stack).to have_attributes(:tenant_id => ext_ms.tenant_id, :evm_owner_id => ext_ms.tenant_identity.id, :miq_group_id => ext_ms.tenant_identity.current_group.id)
    end

    it "sets owner, tenant, and group from the service if the service exists and ems doesn't" do
      svc = service.create!(:tenant_id => tenant.id, :miq_group_id => group.id)
      stack = orchestration_stack.create!(:direct_services => [svc])
      expect(orchestration_stack.count).to eq(1)

      migrate
      stack.reload

      expect(stack).to have_attributes(:tenant_id => svc.tenant_id, :evm_owner_id => svc.tenant_identity.id, :miq_group_id => svc.tenant_identity.current_group.id)
    end

    it "sets owner, tenant, and group from the service if the service and ems exists" do
      ext_ms = ems.create!(:tenant => tenant)
      svc = service.create!(:tenant_id => tenant.id, :miq_group_id => group.id)
      stack = orchestration_stack.create!(:direct_services => [svc], :ext_management_system => ext_ms)
      expect(orchestration_stack.count).to eq(1)

      migrate
      stack.reload

      expect(stack).to have_attributes(:tenant_id => svc.tenant_id, :evm_owner_id => svc.tenant_identity.id, :miq_group_id => svc.tenant_identity.current_group.id)
    end
  end
end
