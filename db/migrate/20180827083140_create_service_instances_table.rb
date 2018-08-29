class CreateServiceInstancesTable < ActiveRecord::Migration[5.0]
  def change
    create_table :service_instances, :id => :bigserial, :force => :cascade do |t|
      t.string :name
      t.string :ems_ref
      t.string :type

      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
      t.references :service_offering, :type => :bigint, :index => true
      t.references :service_parameters_set, :type => :bigint, :index => true

      t.jsonb :extra

      t.datetime :deleted_on
      t.timestamps

      t.index :deleted_on
    end
  end
end
