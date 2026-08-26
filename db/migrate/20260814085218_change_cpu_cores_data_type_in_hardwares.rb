class ChangeCpuCoresDataTypeInHardwares < ActiveRecord::Migration[8.0]
  def up
    change_column :hardwares, :cpu_available_cores, :float
    change_column :hardwares, :cpu_configured_cores, :float
  end

  def down
    change_column :hardwares, :cpu_available_cores, :integer
    change_column :hardwares, :cpu_configured_cores, :integer
  end
end
