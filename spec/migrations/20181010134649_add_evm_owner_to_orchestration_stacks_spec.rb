require_migration

describe AddEvmOwnerToOrchestrationStacks do
  let(:orchestration_stack) { migration_stub(:OrchestrationStack) }

  migration_context :up do
    it "reset column information to avoid RangeError" do
      expect(self).to receive(:clear_caches).at_least(:once)
      stack = orchestration_stack.create!

      migrate

      stack.reload
      stack.update!(:evm_owner_id => 34_000_000_000_001)
      expect(stack.evm_owner_id).to eq(34_000_000_000_001)
    end
  end
end
