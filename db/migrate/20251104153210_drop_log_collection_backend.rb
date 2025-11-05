class DropLogCollectionBackend < ActiveRecord::Migration[7.2]
  def up
    remove_column :miq_servers, :log_file_depot_id
    remove_column :zones, :log_file_depot_id

    drop_table :log_files

    remove_column :file_depots, :support_case
  end

  def down
    create_table :log_files do |t|
      t.string :name
      t.string :description
      t.string :resource_type
      t.bigint :resource_id
      t.bigint :miq_task_id
      t.datetime :created_on, :precision => nil
      t.datetime :updated_on, :precision => nil
      t.datetime :logging_started_on, :precision => nil
      t.datetime :logging_ended_on, :precision => nil
      t.string :state
      t.boolean :historical
      t.string :log_uri
      t.bigint :file_depot_id
      t.string :local_file
      t.index [:miq_task_id], :name => "index_log_files_on_miq_task_id"
      t.index [:resource_id, :resource_type], :name => "index_log_files_on_resource_id_and_resource_type"
    end

    add_column :miq_servers, :log_file_depot_id, :bigint
    add_column :zones, :log_file_depot_id, :bigint

    add_column :file_depots, :support_case, :string
  end
end
