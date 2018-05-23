class AddControllerAndUnitNumberToDisk < ActiveRecord::Migration[5.0]
  def change
    add_column :disks, :key,           :integer
    add_column :disks, :unit_number,   :integer
    add_column :disks, :controller_id, :bigint
  end
end
