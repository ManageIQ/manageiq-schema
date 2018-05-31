class CreatePhysicalStorage < ActiveRecord::Migration[5.0]
  def change
    create_table :physical_storages do |t|
      t.string :ems_ref
      t.string :uid_ems
      t.string :name
      t.string :type
      t.string :access_state
      t.string :health_state
      t.string :overall_health_state
      t.bigint :ems_id
      t.bigint :physical_rack_id
      t.integer :drive_bays
      t.integer :enclosures
      t.integer :canister_slots
      t.timestamps
    end
  end
end
