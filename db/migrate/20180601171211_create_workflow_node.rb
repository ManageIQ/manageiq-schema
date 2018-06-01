class CreateWorkflowNode < ActiveRecord::Migration[5.0]
  def change
    create_table :workflow_nodes do |t|
      t.string  :manager_ref
      t.text    :conditions                 # conditions to launch this node
      t.bigint  :parent_id                  # previous node
      t.bigint  :configuration_script_id    # aka job_template
      t.bigint  :workflow_id                # containing workflow
      t.bigint  :manager_id
      t.index   :workflow_id, :name => 'index_workflow_id'
    end
  end
end
