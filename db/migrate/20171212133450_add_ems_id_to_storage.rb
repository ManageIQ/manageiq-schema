class AddEmsIdToStorage < ActiveRecord::Migration[5.0]
  def up
    add_column :storages, :ems_id, :bigint
    remove_column :host_storages, :ems_ref
  end

  def down
    remove_column :storages, :ems_id, :bigint
    add_column    :host_storages, :ems_ref, :string
  end
end
