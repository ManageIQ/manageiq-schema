class CreateStorageCapabilityValues < ActiveRecord::Migration[6.1]
  def change
    create_table :storage_capability_values do |t|
      t.string :name
      t.string :value
      t.references :storage_capability, :type => :bigint, :index => true
      t.string :ems_ref
      t.timestamps
    end
  end
end