class RenameFlavorsCpusToMatchHardware < ActiveRecord::Migration[6.0]
  def change
    rename_column :flavors, :cpus, :cpu_total_cores
    rename_column :flavors, :cpu_cores, :cpu_cores_per_socket
    add_column    :flavors, :cpu_sockets, :integer, :default => 1
  end
end
