class AddLimitsResourcesToContainers < ActiveRecord::Migration[5.0]
  def change
    add_column :containers, :request_cpu_cores,    :float
    add_column :containers, :request_memory_bytes, :bigint
    add_column :containers, :limit_cpu_cores,      :float
    add_column :containers, :limit_memory_bytes,   :bigint
  end
end
