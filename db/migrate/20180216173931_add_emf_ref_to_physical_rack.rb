class AddEmfRefToPhysicalRack < ActiveRecord::Migration[5.0]
  def change
    add_column :physical_racks, :ems_ref, :string
  end
end
