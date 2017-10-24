class AddTargetsToMiqQueue < ActiveRecord::Migration[5.0]
  def change
    add_column :miq_queue, :targets, "text[]"
  end
end
