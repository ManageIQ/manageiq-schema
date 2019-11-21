class CreateMiqWorkerTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :miq_worker_types do |t|
      t.string  :worker_type, :null => false
      t.string  :bundler_groups, :array => true
      t.integer :kill_priority

      t.index :worker_type, :unique => true
    end
  end
end
