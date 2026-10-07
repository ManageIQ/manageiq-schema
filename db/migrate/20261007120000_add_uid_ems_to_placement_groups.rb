class AddUidEmsToPlacementGroups < ActiveRecord::Migration[8.0]
  def change
    add_column :placement_groups, :uid_ems, :string
    add_index :placement_groups, :uid_ems
  end
end
