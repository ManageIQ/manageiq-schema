class AddReferencesToEmsFolder < ActiveRecord::Migration[5.2]
  def change
    add_reference :vms,            :resource_pool, :type => :bigint, :index => true
    add_reference :vms,            :ems_folder,    :type => :bigint, :index => true
    add_reference :ems_clusters,   :ems_folder,    :type => :bigint, :index => true
    add_reference :hosts,          :ems_folder,    :type => :bigint, :index => true
    add_reference :resource_pools, :host,          :type => :bigint, :index => true
    add_reference :resource_pools, :ems_cluster,   :type => :bigint, :index => true
  end
end
