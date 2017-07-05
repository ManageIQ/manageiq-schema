class AddHashExpressionToMiqAlert < ActiveRecord::Migration[5.0]
  class MiqAlert < ActiveRecord::Base
  end

  def up
    add_column :miq_alerts, :hash_expression, :text

    say_with_time('Add hash expression to MiqAlert for existing alerts') do
      MiqAlert.where("expression NOT LIKE ?", "--- !ruby/object:MiqExpression%").each do |alert|
        alert.hash_expression = alert.expression
        alert.expression = nil
        alert.save
      end
    end

    rename_column :miq_alerts, :expression, :miq_expression
  end

  def down
    say_with_time('Remove hash expression from MiqAlert for existing alerts') do
      MiqAlert.where.not(:hash_expression => nil).each do |alert|
        alert.miq_expression = alert.hash_expression
        alert.save
      end
    end

    remove_column :miq_alerts, :hash_expression
    rename_column :miq_alerts, :miq_expression, :expression
  end
end
