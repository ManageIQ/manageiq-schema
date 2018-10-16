class MigrateOrchStacksToHaveOwnershipConcept < ActiveRecord::Migration[5.0]
  def up
    say_with_time("Migrating existing orchestration stacks to have direct owners, groups, tenant") do
      OrchestrationStack.all.select { |os| os.ems_id.present? }.each do |os|
        os.evm_owner_id = o.ext_management_system.tenant_identity
        os.tenant_id = o.ext_management_system.tenant_identity.current_tenant.id
        os.group_id = o.ext_management_system.tenant_identity.current_group.id
      end

      OrchestrationStack.all.select { |os| os.ems_id.nil? }.each do |os|
        # if orch stack has no ems, can we even set any of this stuff?
      end
    end
  end

  def down
    OrchestrationStack.all.each do |os|
      os.evm_owner_id = nil
      os.tenant_id = nil
      os.group_id = nil
    end
  end
end
