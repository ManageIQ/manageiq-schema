class AddVmsNextCaptureOn < ActiveRecord::Migration[5.0]
  def change
    add_column :containers,       :next_perf_capture_on, :datetime
    add_column :container_groups, :next_perf_capture_on, :datetime
    add_column :container_nodes,  :next_perf_capture_on, :datetime
    add_column :ems_clusters,     :next_perf_capture_on, :datetime
    add_column :hosts,            :next_perf_capture_on, :datetime
    add_column :storages,         :next_perf_capture_on, :datetime
    add_column :vms,              :next_perf_capture_on, :datetime
  end
end
