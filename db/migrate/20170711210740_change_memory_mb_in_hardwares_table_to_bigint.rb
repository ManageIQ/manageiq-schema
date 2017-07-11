class ChangeMemoryMbInHardwaresTableToBigint < ActiveRecord::Migration[5.0]
  def up
    change_column :hardwares, :memory_mb, :bigint
  end

  def down
    change_column :hardwares, :memory_mb, :integer
  end
end
