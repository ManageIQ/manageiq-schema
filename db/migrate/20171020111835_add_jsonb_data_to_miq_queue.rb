class AddJsonbDataToMiqQueue < ActiveRecord::Migration[5.0]
  def change
    add_column :miq_queue, :jsonb_data, :jsonb, :default => {}
  end
end
