class CreatePhysicalChassis < ActiveRecord::Migration[5.0]
  def change
    create_table :physical_chassis do |t|
      t.bigint :ems_id
      t.string :uid_ems
      t.string :ems_ref
      t.bigint :physical_rack_id
      t.string :name
      t.string :vendor
      t.string :type
      t.string :location_led_state
      t.string :health_state
      t.string :overall_health_state
      t.integer :management_module_slot_count
      t.integer :switch_slot_count
      t.integer :fan_slot_count
      t.integer :blade_slot_count
      t.integer :powersupply_slot_count
      t.timestamps
    end

    add_column :physical_servers, :physical_chassis_id, :bigint
  end
end
