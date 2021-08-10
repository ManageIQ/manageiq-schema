class CreateHostInitiatorGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :host_initiator_groups do |t|
      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
      t.references :physical_storage, :type => :bigint, :index => true

      t.string :name
      t.string :status
      t.string :ems_ref
      t.string :uid_ems

      t.timestamps
    end
  end
end
