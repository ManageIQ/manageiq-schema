class AddRestartNeededToVms < ActiveRecord::Migration[5.1]
  def change
    add_column :vms, :restart_needed, :boolean
  end
end
