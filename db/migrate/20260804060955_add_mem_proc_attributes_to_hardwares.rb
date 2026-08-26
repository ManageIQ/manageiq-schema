class AddMemProcAttributesToHardwares < ActiveRecord::Migration[8.0]
  def change
    add_column :hardwares, :memory_mb_configured, :integer
    add_column :hardwares, :cpu_configured_cores, :integer
    add_column :hardwares, :memory_mb_available, :integer
    add_column :hardwares, :cpu_available_cores, :integer
  end
end
