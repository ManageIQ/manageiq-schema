class ChangeResourcesToBeFloatInResourcePools < ActiveRecord::Migration[6.1]
  def up
    %i[memory_reserve memory_limit memory_shares cpu_reserve cpu_limit cpu_shares].each do |column|
      change_column :resource_pools, column, :float
    end
  end

  def down
    %i[memory_reserve memory_limit memory_shares cpu_reserve cpu_limit cpu_shares].each do |column|
      change_column :resource_pools, column, :integer
    end
  end
end
