class DropContainerDeploymentsAndNodes < ActiveRecord::Migration[5.0]
  def up
    drop_table :container_deployments
    drop_table :container_deployment_nodes
  end

  def down
    create_table :container_deployments do |t|
      t.string     :kind
      t.string     :version
      t.boolean    :containerized
      t.string     :method_type
      t.string     :metrics_endpoint
      t.text       :customizations
      t.boolean    :deploy_metrics
      t.boolean    :deploy_registry
      t.belongs_to :automation_task, :type => :bigint
      t.belongs_to :deployed_ems,    :type => :bigint
      t.belongs_to :deployed_on_ems, :type => :bigint
      t.timestamps
    end
    create_table :container_deployment_nodes do |t|
      t.string     :address
      t.string     :name
      t.text       :labels
      t.belongs_to :container_deployment, :type => :bigint
      t.belongs_to :vm, :type => :bigint
      t.text       :docker_storage_devices, :array => true, :default => []
      t.bigint     :docker_storage_data_size
      t.text       :customizations
      t.timestamps
    end
  end
end
