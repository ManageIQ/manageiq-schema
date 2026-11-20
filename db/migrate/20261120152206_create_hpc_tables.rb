class CreateHpcTables < ActiveRecord::Migration[8.0]
  def change
    create_table :hpc_queues do |t|
      t.references :ems, :type => :bigint, :index => true
      t.string   :ems_ref
      t.string   :name
      t.boolean  :accepts_jobs, :default => false, :null => false
      t.boolean  :dispatches_jobs, :default => false, :null => false
      t.string   :native_status
      t.integer  :max_run_time # seconds
      t.integer  :priority
      t.boolean  :is_default, :default => false, :null => false
      t.jsonb    :extra_attributes, :default => {}
      t.datetime :deleted_on, :index => true

      t.timestamps

      t.index %i[ems_id ems_ref], :unique => true, :where => "deleted_on IS NULL"
    end

    create_table :hpc_nodes do |t|
      t.references :ems, :type => :bigint, :index => true
      t.string   :ems_ref
      t.string   :name
      t.string   :state
      t.jsonb    :state_flags, :default => []
      t.string   :native_state
      t.string   :state_reason
      t.integer  :cpus
      t.bigint   :memory_bytes
      t.integer  :gpus
      t.string   :origin
      t.string   :power_state
      t.jsonb    :extra_attributes, :default => {}
      t.datetime :deleted_on, :index => true

      t.timestamps

      t.index %i[ems_id ems_ref], :unique => true, :where => "deleted_on IS NULL"
    end

    create_table :hpc_queue_nodes do |t|
      # The unique (hpc_queue_id, hpc_node_id) index below already covers lookups by hpc_queue_id
      t.references :hpc_queue, :type => :bigint, :index => false
      t.references :hpc_node,  :type => :bigint, :index => true

      t.timestamps

      t.index %i[hpc_queue_id hpc_node_id], :unique => true
    end

    create_table :hpc_jobs do |t|
      t.references :ems,       :type => :bigint, :index => true
      t.references :hpc_queue, :type => :bigint, :index => true
      t.string   :ems_ref
      t.string   :name
      t.string   :state
      t.string   :native_state
      t.string   :state_reason
      t.string   :user_name
      t.string   :array_job_ref
      t.integer  :array_task_ref
      t.integer  :requested_cpus
      t.bigint   :requested_memory_bytes
      t.integer  :requested_gpus
      t.integer  :requested_nodes
      t.text     :native_node_list
      t.datetime :submitted_on
      t.datetime :started_on
      t.datetime :finished_on
      t.integer  :exit_code
      t.jsonb    :extra_attributes, :default => {}
      t.datetime :deleted_on, :index => true

      t.timestamps

      t.index %i[ems_id ems_ref], :unique => true, :where => "deleted_on IS NULL"
    end

    create_table :hpc_job_nodes do |t|
      # The unique (hpc_job_id, hpc_node_id) index below already covers lookups by hpc_job_id
      t.references :hpc_job,  :type => :bigint, :index => false
      t.references :hpc_node, :type => :bigint, :index => true

      t.timestamps

      t.index %i[hpc_job_id hpc_node_id], :unique => true
    end
  end
end
