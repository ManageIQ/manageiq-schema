class AddThinAndFormatToDisk < ActiveRecord::Migration[5.1]
  def change
    add_column :disks, :thin, :boolean
    add_column :disks, :format, :string
  end
end
