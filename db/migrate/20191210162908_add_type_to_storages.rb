class AddTypeToStorages < ActiveRecord::Migration[5.1]
  def change
    add_column :storages, :type, :string
  end
end
