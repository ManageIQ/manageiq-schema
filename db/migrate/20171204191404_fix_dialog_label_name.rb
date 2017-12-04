class FixDialogLabelName < ActiveRecord::Migration[5.0]
  def change
    rename_column :dialogs, :label, :name
  end
end
