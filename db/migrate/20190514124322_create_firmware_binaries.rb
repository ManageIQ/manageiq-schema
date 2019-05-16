class CreateFirmwareBinaries < ActiveRecord::Migration[5.0]
  def change
    create_table :firmware_binaries do |t|
      t.string     :name
      t.string     :external_ref
      t.text       :description
      t.string     :version
      t.string     :type
      t.references :firmware_registry, :type => :bigint, :index => true
      t.timestamps
    end
  end
end
