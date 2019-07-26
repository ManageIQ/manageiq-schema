class CreateBudgetHistory < ActiveRecord::Migration[5.1]
  def change
    create_table :budget_histories do |t|
      t.bigint   :budget_id
      t.bigint   :fixed_compute_metric
      t.string   :interval_range
      t.datetime :last_modified
      t.decimal  :cpu_allocated_cost, :precision => 20, :scale => 3
      t.decimal  :total_cost, :precision => 20, :scale => 3
      t.decimal  :cpu_cost, :precision => 20, :scale => 3
      t.decimal  :cpu_used_cost, :precision => 20, :scale => 3
      t.decimal  :disk_io_used_cost, :precision => 20, :scale => 3
      t.decimal  :disk_io_cost, :precision => 20, :scale => 3
      t.decimal  :fixed_compute_1_cost, :precision => 20, :scale => 3
      t.decimal  :fixed_cost, :precision => 20, :scale => 3
      t.decimal  :memory_allocated_cost, :precision => 20, :scale => 3
      t.decimal  :memory_cost, :precision => 20, :scale => 3
      t.decimal  :memory_used_cost, :precision => 20, :scale => 3
      t.decimal  :net_io_used_cost, :precision => 20, :scale => 3
      t.decimal  :net_io_cost, :precision => 20, :scale => 3
      t.decimal  :storage_allocated_cost, :precision => 20, :scale => 3
      t.decimal  :storage_cost, :precision => 20, :scale => 3
      t.decimal  :storage_used_cost, :precision => 20, :scale => 3
    end
  end
end
