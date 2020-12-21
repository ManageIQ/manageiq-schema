class CreateVolumeMappings < ActiveRecord::Migration[5.2]
  def change
    create_table :volume_mappings do |t|
      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
      t.references :cloud_volume, :type => :bigint, :index => true
      t.references :host_initiator, :type => :bigint, :index => true

      t.string :ems_ref
      t.string :uid_ems

      t.integer :lun

      t.timestamps
    end
  end
end
