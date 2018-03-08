class AddIndexOnTypeAndIdOnMiqQueue < ActiveRecord::Migration[5.0]
  def change
    add_index :miq_queue, [:handler_id, :handler_type]
  end
end
