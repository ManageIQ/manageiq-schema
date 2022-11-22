class CreatePhysicalServerProfileTemplates < ActiveRecord::Migration[6.1]
  def change
    create_table :physical_server_profile_templates do |t|
      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
      t.string :ems_ref
      t.string :name
      t.string :type, :index => true
      t.timestamps
    end
  end
end
