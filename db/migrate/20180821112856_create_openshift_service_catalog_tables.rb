class CreateOpenshiftServiceCatalogTables < ActiveRecord::Migration[5.0]
  def change
    create_table :container_service_brokers, id: :bigserial, force: :cascade do |t|
      t.string :name
      t.string :kind
      t.string :ems_ref
      t.integer :resource_version
      t.text :url

      t.references :ems_id, :type => :bigint, :index => true, :references => :ext_management_systems
      t.references :container_projects, :type => :bigint, :index => true

      t.jsonb :extra

      t.datetime :ems_created_on
      t.timestamps
    end

    create_table :container_service_classes, id: :bigserial, force: :cascade do |t|
      t.string :name
      t.string :kind
      t.string :status
      t.string :ems_ref
      t.integer :resource_version
      t.text :description
      t.boolean :bindable
      t.boolean :plan_updatable

      t.references :ems_id, :type => :bigint, :index => true, :references => :ext_management_systems
      t.references :container_projects, :type => :bigint, :index => true
      t.references :container_service_brokers, :type => :bigint, :index => true

      t.jsonb :extra

      t.datetime :ems_created_on
      t.timestamps
    end

    create_table :container_service_plans, id: :bigserial, force: :cascade do |t|
      t.string :name
      t.string :kind
      t.string :status
      t.string :ems_ref
      t.integer :resource_version
      t.text :description
      t.boolean :free

      t.references :ems_id, :type => :bigint, :index => true, :references => :ext_management_systems
      t.references :container_projects, :type => :bigint, :index => true
      t.references :container_service_classes, :type => :bigint, :index => true

      t.jsonb :extra

      t.datetime :ems_created_on
      t.timestamps
    end

    create_table :container_service_instances, id: :bigserial, force: :cascade do |t|
      t.string :name
      t.string :kind
      t.string :status
      t.string :ems_ref
      t.string :secret_name
      t.integer :resource_version

      t.references :ems_id, :type => :bigint, :index => true, :references => :ext_management_systems
      t.references :container_projects, :type => :bigint, :index => true
      t.references :container_service_classes, :type => :bigint, :index => { :name => 'csi_on_container_service_classes' }
      t.references :container_service_plans, :type => :bigint, :index => true

      t.jsonb :parameters
      t.jsonb :parameters_from
      t.jsonb :extra

      t.datetime :ems_created_on
      t.timestamps
    end

    create_table :container_service_bindings, id: :bigserial, force: :cascade do |t|
      t.string :name
      t.string :kind
      t.string :status
      t.string :ems_ref
      t.string :secret_name
      t.integer :resource_version

      t.references :ems_id, :type => :bigint, :index => true, :references => :ext_management_systems
      t.references :container_projects, :type => :bigint, :index => true
      t.references :container_service_instances, :type => :bigint, :index => { :name => 'csb_on_container_service_instances' }

      t.jsonb :parameters
      t.jsonb :parameters_from
      t.jsonb :extra

      t.datetime :ems_created_on
      t.timestamps
    end

    create_table :container_secrets, id: :bigserial, force: :cascade do |t|
      t.string :name
      t.string :kind
      t.string :ems_ref
      t.integer :resource_version

      t.references :ems_id, :type => :bigint, :index => true, :references => :ext_management_systems
      t.references :container_projects, :type => :bigint, :index => true

      t.jsonb :extra

      t.datetime :ems_created_on
      t.timestamps
    end
  end
end
