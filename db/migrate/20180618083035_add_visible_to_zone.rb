class AddVisibleToZone < ActiveRecord::Migration[5.0]
  def change
    add_column :zones, :visible, :boolean, :default => true
    reversible do |dir|
      dir.up do
        Zone.reset_column_information
        Zone.seed
      end
    end
  end
end
