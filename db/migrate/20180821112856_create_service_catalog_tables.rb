class CreateServiceCatalogTables < ActiveRecord::Migration[5.0]
  def change
    create_table :service_offerings, :id => :bigserial, :force => :cascade do |t|
      t.string :name
      t.string :ems_ref
      t.string :type
      t.text :description

      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system

      t.jsonb :extra

      t.datetime :deleted_on
      t.timestamps

      t.index :deleted_on
    end

    create_table :service_parameters_sets, :id => :bigserial, :force => :cascade do |t|
      t.string :name
      t.string :ems_ref
      t.string :type
      t.text :description

      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
      t.references :service_offering, :type => :bigint, :index => true

      t.jsonb :extra

      t.datetime :deleted_on
      t.timestamps

      t.index :deleted_on
    end
  end
end
