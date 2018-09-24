class RenamePhysicalDiskType < ActiveRecord::Migration[5.0]
  def change
    rename_column :physical_disks, :type, :controller_type
  end
end
