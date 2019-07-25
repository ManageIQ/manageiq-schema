class AddEvmOwnerToOrchestrationStacks < ActiveRecord::Migration[5.0]
  class OrchestrationStack < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
  end

  def change
    add_reference :orchestration_stacks, :evm_owner, :type => :bigint, :index => true
    add_reference :orchestration_stacks, :miq_group, :type => :bigint, :index => true
    add_reference :orchestration_stacks, :tenant,    :type => :bigint, :index => true
    OrchestrationStack.reset_column_information
  end
end
