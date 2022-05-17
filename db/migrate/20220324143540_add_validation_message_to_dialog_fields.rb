class AddValidationMessageToDialogFields < ActiveRecord::Migration[6.0]
  def change
    add_column :dialog_fields, :validator_message, :string
  end
end
