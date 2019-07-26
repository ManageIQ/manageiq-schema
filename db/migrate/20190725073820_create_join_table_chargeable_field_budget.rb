class CreateJoinTableChargeableFieldBudget < ActiveRecord::Migration[5.1]
  def change
    create_table :chargeable_field_budgets do |t|
      t.bigint :chargeable_field_id
      t.bigint :budget_id
      t.index :chargeable_field_id, :name => 'index_chargeable_field_id'
      t.index :budget_id, :name => 'index_budget_id'
      t.timestamps
    end
  end
end
