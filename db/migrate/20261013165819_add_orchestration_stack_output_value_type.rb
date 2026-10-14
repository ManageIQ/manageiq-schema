class AddOrchestrationStackOutputValueType < ActiveRecord::Migration[8.0]
  def change
    add_column :orchestration_stack_outputs, :value_type, :string
  end
end
