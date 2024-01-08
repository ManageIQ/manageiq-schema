class AddOrchestrationStackConfigurationScript < ActiveRecord::Migration[6.1]
  def change
    add_reference :orchestration_stacks, :configuration_script, :type => :bigint, :index => true
  end
end
