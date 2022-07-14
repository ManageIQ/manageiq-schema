class CreateCloudDatabaseServer < ActiveRecord::Migration[6.0]
  def change
    create_table :cloud_database_servers do |t|
      t.string :name
      t.string :type, :index => true
      t.string :ems_ref
      t.string :server_type
      t.string :status
      t.string :version
      t.bigint :resource_group_id
      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
      t.timestamps
    end

    add_reference :cloud_databases, :cloud_database_server
  end
end
