class CreateStorageCapabilityValues < ActiveRecord::Migration[6.1]
  def change
    create_table :storage_capability_values do |t|
      t.string :uuid
      t.string :value
      t.bigint :capability_id
      t.timestamps
    end
  end
end