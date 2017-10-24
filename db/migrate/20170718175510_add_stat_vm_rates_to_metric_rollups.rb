class AddStatVmRatesToMetricRollups < ActiveRecord::Migration[5.0]
  def change
    add_column :metric_rollups, :stat_vm_create_rate, :integer
    add_column :metric_rollups, :stat_vm_delete_rate, :integer
  end
end
