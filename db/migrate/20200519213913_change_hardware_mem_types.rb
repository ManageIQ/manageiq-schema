class ChangeHardwareMemTypes < ActiveRecord::Migration[5.2]
  class Hardware < ActiveRecord::Base
  end

  def up
    change_column :hardwares, :memory_mb, :bigint
  end

  def down
    say_with_time "clamp oversized memory_mb values" do
      Hardware.where("memory_mb > 2147483647").update_all(:memory_mb => 2_147_483_647)
    end

    change_column :hardwares, :memory_mb, :integer
  end
end
