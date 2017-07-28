class AddExpressionToEntitlements < ActiveRecord::Migration[5.0]
  def change
    add_column :entitlements, :filter_expression, :text
  end
end
