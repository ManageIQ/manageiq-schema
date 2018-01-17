class RemoveMiddlewareTables < ActiveRecord::Migration[5.0]
  def up
    drop_table :middleware_datasources
    drop_table :middleware_deployments
    drop_table :middleware_diagnostic_reports
    drop_table :middleware_domains
    drop_table :middleware_messagings
    drop_table :middleware_server_groups
    drop_table :middleware_servers
  end

  def down
    create_table :middleware_datasources do |t|
      t.string :name # name of the datasource
      t.string :ems_ref # path
      t.string :nativeid
      t.bigint :server_id
      t.text   :properties
      t.bigint :ems_id
      t.string :feed
      t.string :type
      t.timestamps
    end

    add_index :middleware_datasources, :type

    create_table :middleware_deployments do |t|
      t.string :name # name of the datasource
      t.string :ems_ref # path
      t.string :nativeid
      t.bigint :server_id
      t.bigint :ems_id
      t.string :status
      t.string :feed
      t.text   :properties
      t.bigint :server_group_id
      t.string :type
      t.timestamps
    end

    add_index :middleware_deployments, :type

    create_table :middleware_diagnostic_reports do |t|
      t.datetime :queued_at
      t.string   :requesting_user
      t.string   :status
      t.string   :error_message
      t.bigint   :middleware_server_id
      t.timestamps
    end

    add_index :middleware_diagnostic_reports, :middleware_server_id

    create_table :middleware_domains do |t|
      t.string :name
      t.string :ems_ref
      t.string :nativeid
      t.string :feed
      t.string :type_path
      t.string :profile
      t.text   :properties
      t.bigint :ems_id
      t.string :type
      t.timestamps
    end

    add_index :middleware_domains, :type

    create_table :middleware_messagings do |t|
      t.string :name
      t.string :ems_ref
      t.string :nativeid
      t.string :feed
      t.bigint :server_id
      t.text   :properties
      t.bigint :ems_id
      t.string :messaging_type
      t.string :type
      t.timestamps
    end

    add_index :middleware_messagings, :type

    create_table :middleware_server_groups do |t|
      t.string :name
      t.string :ems_ref
      t.string :nativeid
      t.string :feed
      t.string :type_path
      t.string :profile
      t.text   :properties
      t.bigint :domain_id
      t.string :type
      t.timestamps
    end

    add_index :middleware_server_groups, :type

    create_table :middleware_servers do |t|
      t.string :name
      t.string :feed
      t.string :ems_ref
      t.string :nativeid
      t.string :type_path
      t.string :hostname
      t.string :product
      t.text   :properties
      t.bigint :ems_id
      t.string :lives_on_type
      t.bigint :lives_on_id
      t.bigint :server_group_id
      t.string :type
      t.timestamps
    end

    add_index :middleware_servers, :type
    add_index :middleware_servers, %i(lives_on_id lives_on_type)
  end
end
