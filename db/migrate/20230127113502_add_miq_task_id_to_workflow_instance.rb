class AddMiqTaskIdToWorkflowInstance < ActiveRecord::Migration[6.1]
  def change
    add_column :workflow_instances, :miq_task_id, :bigint, :index => true
  end
end
