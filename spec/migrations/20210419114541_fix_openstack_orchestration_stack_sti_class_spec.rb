require_migration

RSpec.describe FixOpenstackOrchestrationStackStiClass do
  let(:stack_stub) { migration_stub(:OrchestrationStack) }

  migration_context :up do
    it "Fixes the STI class of the OpenStack Orchestration Stacks" do
      stack = stack_stub.create!(:type => "ManageIQ::Providers::CloudManager::OrchestrationStack")

      migrate

      expect(stack.reload.type).to eq("ManageIQ::Providers::Openstack::CloudManager::OrchestrationStack")
    end

    it "Doesn't impact other Orchestration Stack types" do
      stack = stack_stub.create!(:type => "ManageIQ::Providers::AwesomeCloud::CloudManager::OrchestrationStack")

      migrate

      expect(stack.reload.type).to eq("ManageIQ::Providers::AwesomeCloud::CloudManager::OrchestrationStack")
    end
  end

  migration_context :down do
    it "Reverts the STI class of the OpenStack Orchestration Stacks" do
      stack = stack_stub.create!(:type => "ManageIQ::Providers::Openstack::CloudManager::OrchestrationStack")

      migrate

      expect(stack.reload.type).to eq("ManageIQ::Providers::CloudManager::OrchestrationStack")
    end

    it "Doesn't impact other Orchestration Stack types" do
      stack = stack_stub.create!(:type => "ManageIQ::Providers::AwesomeCloud::CloudManager::OrchestrationStack")

      migrate

      expect(stack.reload.type).to eq("ManageIQ::Providers::AwesomeCloud::CloudManager::OrchestrationStack")
    end
  end
end
