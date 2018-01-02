class DropVimPerformanceTagValues < ActiveRecord::Migration[5.0]
  def change
    drop_table :vim_performance_tag_values do |t|
      t.string :association_type
      t.string :category
      t.string :tag_name
      t.string :column_name
      t.float  :value
      t.text   :assoc_ids
      t.bigint :metric_id
      t.string :metric_type
      t.index [:metric_id, :metric_type]
    end
  end
end
