class AddAncestryToResourcePool < ActiveRecord::Migration[5.2]
  def change
    add_column :resource_pools, :ancestry, :string
    add_index :resource_pools, :ancestry
  end
end
