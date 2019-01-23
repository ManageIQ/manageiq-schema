class AddAccessibleToHostStorages < ActiveRecord::Migration[5.0]
  def change
    add_column :host_storages, :accessible, :boolean
  end
end
