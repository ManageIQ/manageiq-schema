class ChangeDialogFieldDescriptionFromStringToText < ActiveRecord::Migration[5.0]
  def up
    change_column :dialog_fields, :description, :text
  end

  def down
    change_column :dialog_fields, :description, :string
  end
end
