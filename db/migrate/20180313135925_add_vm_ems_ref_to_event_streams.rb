class AddVmEmsRefToEventStreams < ActiveRecord::Migration[5.0]
  def change
    add_column :event_streams, :vm_ems_ref,      :string
    add_column :event_streams, :dest_vm_ems_ref, :string
  end
end
