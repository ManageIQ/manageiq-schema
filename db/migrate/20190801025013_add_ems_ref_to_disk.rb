class AddEmsRefToDisk < ActiveRecord::Migration[5.1]
  def change
    add_column :disks, :ems_ref, :string
  end
end
