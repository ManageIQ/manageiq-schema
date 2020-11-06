class AddSystemUidToMiqWorkers < ActiveRecord::Migration[5.2]
  def change
    add_column :miq_workers, :system_uid, :string
  end
end
