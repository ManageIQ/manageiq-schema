class AddParentIdToLans < ActiveRecord::Migration[5.0]
  def change
    add_column :lans, :parent_id, :bigint
  end
end
