class AddUniqueSetSizeToMiqServersMiqWorkers < ActiveRecord::Migration[5.0]
  def change
    add_column :miq_servers, :unique_set_size, :decimal, :precision => 20, :scale => 0
    add_column :miq_workers, :unique_set_size, :decimal, :precision => 20, :scale => 0
  end
end
