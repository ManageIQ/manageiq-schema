class AddEvmOwnerToOrchestrationStacks < ActiveRecord::Migration[5.0]
  def change
    add_reference :orchestration_stacks, :evm_owner, :type => :bigint, :index => true
    add_reference :orchestration_stacks, :miq_group, :type => :bigint, :index => true
    add_reference :orchestration_stacks, :tenant,    :type => :bigint, :index => true
  end
end
