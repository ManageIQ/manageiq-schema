class CreateWorkflowMigrations < ActiveRecord::Migration[6.1]
  def change
    create_table :workflows do |t|
      t.references :ems,           :type => :bigint, :index => true, :references => :ext_management_system
      t.references :tenant,        :type => :bigint, :index => true
      t.references :git_reference, :type => :bigint, :index => true
      t.references :evm_owner,     :type => :bigint, :index => true, :references => :user
      t.references :miq_group,     :type => :bigint, :index => true
      t.string :type, :index => true
      t.string :name
      t.jsonb :workflow_content, :default => {}
      t.jsonb :credentials, :default => {}

      t.timestamps
    end

    create_table :workflow_instances do |t|
      t.references :ems,      :type => :bigint, :index => true, :references => :ext_management_system
      t.references :workflow, :type => :bigint, :index => true
      t.references :tenant,   :type => :bigint, :index => true
      t.references :evm_owner,     :type => :bigint, :index => true, :references => :user
      t.references :miq_group,     :type => :bigint, :index => true
      t.references :miq_task, :type => :bigint, :index => true
      t.string :type, :index => true
      t.string :userid
      t.string :status
      t.jsonb :workflow_content, :default => {}
      t.jsonb :credentials, :default => {}
      t.jsonb :context, :default => {}
      t.jsonb :output, :default => {}

      t.timestamps
    end
  end
end
