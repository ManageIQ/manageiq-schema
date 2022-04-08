class PlacementGroupAdditions < ActiveRecord::Migration[6.0]
  def change
    create_table :placement_groups do |t|
      t.string :name
      t.string :policy
      t.string :ems_ref
      t.string :type,                  :index => true

      t.references :availability_zone, :type => :bigint
      t.references :cloud_tenant,      :type => :bigint
      t.references :ems,               :type => :bigint

      t.timestamps
    end

    add_reference :vms, :placement_group, :type => :bigint
  end
end
