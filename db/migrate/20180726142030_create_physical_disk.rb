class CreatePhysicalDisk < ActiveRecord::Migration[5.0]
  def change
    create_table :physical_disks do |t|
      t.string :model
      t.string :vendor
      t.string :status
      t.string :location
      t.index  :location
      t.string :serial_number
      t.string :health_state
      t.string :type
      t.string :disk_size
      t.bigint :physical_storage_id
      t.index  :physical_storage_id
      t.timestamps
    end
  end
end
