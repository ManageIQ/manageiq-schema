class AddVendorToConfiguredSystems < ActiveRecord::Migration[5.2]
  def change
    add_column :configured_systems, :vendor, :string
  end
end
