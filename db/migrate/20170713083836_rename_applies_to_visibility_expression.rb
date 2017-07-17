class RenameAppliesToVisibilityExpression < ActiveRecord::Migration[5.0]
  def change
    rename_column :custom_buttons, :applies_to_exp, :visibility_expression
  end
end
