class AddStatusToStorages < ActiveRecord::Migration[5.0]
  def change
    add_column :storages, :status, :string
  end
end
