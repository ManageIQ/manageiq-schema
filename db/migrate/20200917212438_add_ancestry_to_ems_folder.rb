class AddAncestryToEmsFolder < ActiveRecord::Migration[5.2]
  def change
    add_column :ems_folders, :ancestry, :string
    add_index :ems_folders, :ancestry
  end
end
