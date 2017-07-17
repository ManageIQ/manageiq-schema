class AddEnablementExpressionAndDisabledText < ActiveRecord::Migration[5.0]
  def change
    add_column :custom_buttons, :enablement_expression, :text
    add_column :custom_buttons, :disabled_text, :text
  end
end
