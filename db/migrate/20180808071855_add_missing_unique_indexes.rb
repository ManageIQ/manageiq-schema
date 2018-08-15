class AddMissingUniqueIndexes < ActiveRecord::Migration[5.0]
  def change
    add_index :orchestration_stack_outputs,    %i(stack_id ems_ref), :unique => true
    add_index :orchestration_stack_parameters, %i(stack_id ems_ref), :unique => true
    add_index :orchestration_stack_resources,  %i(stack_id ems_ref), :unique => true

    remove_index :hardwares, :vm_or_template_id
    remove_index :operating_systems, :vm_or_template_id

    add_index :hardwares,         %i(vm_or_template_id),       :unique => true
    add_index :operating_systems, %i(vm_or_template_id),       :unique => true
    add_index :disks,             %i(hardware_id device_name), :unique => true
    add_index :networks,          %i(hardware_id description), :unique => true
  end
end
