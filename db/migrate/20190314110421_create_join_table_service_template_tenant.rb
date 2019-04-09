class CreateJoinTableServiceTemplateTenant < ActiveRecord::Migration[5.0]
  def change
    create_table :service_template_tenants do |t|
      t.bigint :service_template_id
      t.bigint :tenant_id
      t.index :service_template_id, :name => 'index_service_template_id'
      t.index :tenant_id, :name => 'index_tenant_id'
      t.timestamps
    end
  end
end
