require_migration

describe MigrateOrchStacksToHaveOwnershipConcept do
  let(:orchestration_stack) { migration_stub(:OrchestrationStack) }
  let(:ems) { migration_stub(:ExtManagementSystem) }
  let(:service) { migration_stub(:Service) }
  let(:tenant) { migration_stub(:Tenant).create! }
  let(:group) { migration_stub(:MiqGroup).create!(:tenant_id => tenant.id) }
  let!(:user) { migration_stub(:User).create!(:userid => "admin", :miq_groups => [group], :current_group => group) }

  migration_context :up do
    it "sets owner, tenant, and group from the user if neither the ems and service exist" do
      stack = orchestration_stack.create!(:ems_id => nil)
      expect(orchestration_stack.count).to eq(1)

      migrate
      stack.reload

      expect(stack).to have_attributes(:tenant_id => user.current_tenant.id, :evm_owner_id => user.id, :miq_group_id => user.current_group.id)
    end

    it "sets owner, tenant, and group from the ems if the ems exists and the service doesn't" do
      ext_ms = ems.create!(:tenant_id => tenant.id)
      stack = orchestration_stack.create!(:ems_id => ext_ms.id)
      expect(orchestration_stack.count).to eq(1)

      migrate
      stack.reload

      expect(stack).to have_attributes(:tenant_id => ext_ms.tenant_id, :evm_owner_id => ext_ms.tenant_identity.id, :miq_group_id => ext_ms.tenant_identity.current_group.id)
    end

    it "sets owner, tenant, and group from the user if the ems was deleted but the stack ems id is still set" do
      stack = orchestration_stack.create!(:ems_id => -2)
      expect(orchestration_stack.count).to eq(1)

      migrate
      stack.reload

      expect(stack).to have_attributes(:tenant_id => user.current_tenant.id, :evm_owner_id => user.id, :miq_group_id => user.current_group.id)
    end

    it "sets owner, tenant, and group from the service if the service exists and ems doesn't" do
      svc = service.create!(:tenant_id => tenant.id, :miq_group_id => group.id)
      stack = orchestration_stack.create!(:direct_service_ids => [svc.id])
      expect(orchestration_stack.count).to eq(1)

      migrate
      stack.reload

      expect(stack).to have_attributes(:tenant_id => svc.tenant_id, :evm_owner_id => svc.tenant_identity.id, :miq_group_id => svc.tenant_identity.current_group.id)
    end

    it "sets owner, tenant, and group from the service if the service and ems exists" do
      ext_ms = ems.create!(:tenant_id => tenant.id)
      svc = service.create!(:tenant_id => tenant.id, :miq_group_id => group.id)
      stack = orchestration_stack.create!(:direct_service_ids => [svc.id], :ems_id => ext_ms.id)
      expect(orchestration_stack.count).to eq(1)

      migrate
      stack.reload

      expect(stack).to have_attributes(:tenant_id => svc.tenant_id, :evm_owner_id => svc.tenant_identity.id, :miq_group_id => svc.tenant_identity.current_group.id)
    end
  end
end
