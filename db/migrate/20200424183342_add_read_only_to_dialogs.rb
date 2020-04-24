class AddReadOnlyToDialogs < ActiveRecord::Migration[5.1]
  def change
    add_column :dialogs, :system, :boolean
  end
end
