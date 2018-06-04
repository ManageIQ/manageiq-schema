class CreateConfigurationWorkflowNode < ActiveRecord::Migration[5.0]
  def change
    create_table :configuration_workflow_nodes do |t|
      t.string  :manager_ref
      t.text    :conditions                 # conditions to launch this node
      t.bigint  :parent_id                  # previous node
      t.bigint  :configuration_script_id    # aka job_template
      t.bigint  :configuration_workflow_id  # configuration_workflow that contains this
      t.bigint  :manager_id
      t.timestamps
      t.index(:configuration_workflow_id, :name => 'index_configuration_workflow_id')
    end
  end
end
