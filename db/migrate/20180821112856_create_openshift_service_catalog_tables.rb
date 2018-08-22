class CreateOpenshiftServiceCatalogTables < ActiveRecord::Migration[5.0]
  def change
    create_table :container_service_classes, :id => :bigserial, :force => :cascade do |t|
      t.string :name
      t.string :ems_ref
      t.integer :resource_version
      t.text :description

      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
      t.references :container_project, :type => :bigint, :index => true
      t.references :container_service_broker, :type => :bigint, :index => true

      t.jsonb :extra

      t.datetime :ems_created_on
      t.timestamps
    end

    create_table :container_service_plans, :id => :bigserial, :force => :cascade do |t|
      t.string :name
      t.string :ems_ref
      t.integer :resource_version
      t.text :description

      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
      t.references :container_project, :type => :bigint, :index => true
      t.references :container_service_class, :type => :bigint, :index => true

      t.jsonb :extra

      t.datetime :ems_created_on
      t.timestamps
    end

    create_table :container_service_instances, :id => :bigserial, :force => :cascade do |t|
      t.string :name
      t.string :ems_ref
      t.string :secret_name
      t.integer :resource_version
      t.string :generate_name

      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
      t.references :container_project, :type => :bigint, :index => true
      t.references :container_service_class, :type => :bigint, :index => {:name => 'csi_on_container_service_classes'}
      t.references :container_service_plan, :type => :bigint, :index => true

      t.jsonb :extra

      t.datetime :ems_created_on
      t.timestamps
    end
  end
end
