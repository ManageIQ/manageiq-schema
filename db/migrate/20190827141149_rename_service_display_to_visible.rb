class RenameServiceDisplayToVisible < ActiveRecord::Migration[5.0]
  def change
    rename_column :services, :display, :visible
  end
end
