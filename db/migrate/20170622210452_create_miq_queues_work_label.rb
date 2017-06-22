class CreateMiqQueuesWorkLabel < ActiveRecord::Migration[5.0]
  def change
    add_column :miq_queue, :tracking_label, :string, :comment => 'label to track requests through the system'
  end
end
