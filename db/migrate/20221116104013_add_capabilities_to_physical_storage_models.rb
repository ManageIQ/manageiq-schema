class AddCapabilitiesToPhysicalStorageModels < ActiveRecord::Migration[6.1]
  def change
    add_column :physical_storage_families, :capabilities, :jsonb, :default => {}
    add_column :physical_storages, :capabilities, :jsonb, :default => {}
    add_column :storage_resources, :capabilities, :jsonb, :default => {}
    add_column :storage_services, :capabilities, :jsonb, :default => {}
  end
end
