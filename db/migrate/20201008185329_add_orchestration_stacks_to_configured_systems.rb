class AddOrchestrationStacksToConfiguredSystems < ActiveRecord::Migration[5.2]
  def change
    add_reference :configured_systems, :orchestration_stack
  end
end
