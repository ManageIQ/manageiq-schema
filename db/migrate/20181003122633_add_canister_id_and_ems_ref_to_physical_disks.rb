class AddCanisterIdAndEmsRefToPhysicalDisks < ActiveRecord::Migration[5.0]
  def change
    add_reference :physical_disks, :canister, :type => :bigint
    add_column :physical_disks, :ems_ref, :string
  end
end
