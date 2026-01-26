class DropMiqServerHasVixDiskLib < ActiveRecord::Migration[7.2]
  def change
    remove_column :miq_servers, :has_vix_disk_lib, :boolean
  end
end
