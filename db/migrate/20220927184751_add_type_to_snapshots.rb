class AddTypeToSnapshots < ActiveRecord::Migration[6.1]
  def change
    add_column :snapshots, :type, :string
    add_index :snapshots, :type
  end
end
