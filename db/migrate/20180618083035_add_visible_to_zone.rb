class AddVisibleToZone < ActiveRecord::Migration[5.0]
  def change
    add_column :zones, :visible, :boolean, :default => true
  end
end
