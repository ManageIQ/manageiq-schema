class CreateBudget < ActiveRecord::Migration[5.1]
  def change
    create_table :budgets do |t|
      t.string :action
      t.decimal :amount, :precision => 20, :scale => 0
      t.references :resource, :type => :bigint, :polymorphic => true
      t.references :chargeable_field, :type => :bigint
      t.references :currency, :type => :bigint
    end
  end
end
