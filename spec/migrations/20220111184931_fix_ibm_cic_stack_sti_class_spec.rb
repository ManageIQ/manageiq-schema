require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe FixIbmCicStackStiClass do
  let(:ems_stub)   { migration_stub(:ExtManagementSystem) }
  let(:stack_stub) { migration_stub(:OrchestrationStack) }

  migration_context :up do
    it "Fixes IBM CIC OrchestrationStack STI class" do
      ibm_cic = ems_stub.create(:type => "ManageIQ::Providers::IbmCic::CloudManager")
      stack   = stack_stub.create(:ext_management_system => ibm_cic)

      migrate

      expect(stack.reload.type).to eq("ManageIQ::Providers::IbmCic::CloudManager::OrchestrationStack")
    end
  end

  migration_context :down do
    it "Resets IBM CIC OrchestrationStack STI class" do
      ibm_cic = ems_stub.create(:type => "ManageIQ::Providers::IbmCic::CloudManager")
      stack   = stack_stub.create(:ext_management_system => ibm_cic, :type => "ManageIQ::Providers::IbmCic::CloudManager::OrchestrationStack")

      migrate

      expect(stack.reload.type).to be_nil
    end
  end
end
