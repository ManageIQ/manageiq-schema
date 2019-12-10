class AddMaintenanceModeToStorages < ActiveRecord::Migration[5.1]
  def change
    add_column :storages, :maintenance, :boolean
    add_column :storages, :maintenance_reason, :string
  end
end
