class CreateCanister < ActiveRecord::Migration[5.0]
  def change
    create_table :canisters do |t|
      t.string :ems_ref
      t.string :serial_number
      t.string :name
      t.string :position
      t.string :status
      t.string :health_state
      t.string :disk_bus_type
      t.string :phy_isolation
      t.string :controller_redundancy_status
      t.integer :disks
      t.integer :disk_channel
      t.integer :system_cache_memory
      t.string :power_state
      t.string :host_ports
      t.string :hardware_version
      t.bigint :physical_storage_id
      t.timestamps
    end
  end
end
