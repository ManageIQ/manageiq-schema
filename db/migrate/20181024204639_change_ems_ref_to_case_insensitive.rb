class ChangeEmsRefToCaseInsensitive < ActiveRecord::Migration[5.0]
  def up
    enable_extension :citext
    change_column :availability_zones, :ems_ref, :citext
    change_column :cloud_networks, :ems_ref, :citext
    change_column :cloud_subnets, :ems_ref, :citext
    change_column :cloud_volumes, :ems_ref, :citext
    change_column :flavors, :ems_ref, :citext
    change_column :floating_ips, :ems_ref, :citext
    change_column :load_balancers, :ems_ref, :citext
    change_column :load_balancer_health_checks, :ems_ref, :citext
    change_column :load_balancer_listeners, :ems_ref, :citext
    change_column :load_balancer_pools, :ems_ref, :citext
    change_column :load_balancer_pool_members, :ems_ref, :citext
    change_column :network_groups, :ems_ref, :citext
    change_column :network_ports, :ems_ref, :citext
    change_column :network_routers, :ems_ref, :citext
    change_column :vms, :ems_ref, :citext
  end

  def down
    change_column :availability_zones, :ems_ref, :text
    change_column :cloud_networks, :ems_ref, :text
    change_column :cloud_subnets, :ems_ref, :text
    change_column :cloud_volumes, :ems_ref, :text
    change_column :flavors, :ems_ref, :text
    change_column :floating_ips, :ems_ref, :text
    change_column :load_balancers, :ems_ref, :text
    change_column :load_balancer_health_checks, :ems_ref, :text
    change_column :load_balancer_listeners, :ems_ref, :text
    change_column :load_balancer_pools, :ems_ref, :text
    change_column :load_balancer_pool_members, :ems_ref, :text
    change_column :network_groups, :ems_ref, :text
    change_column :network_ports, :ems_ref, :text
    change_column :network_routers, :ems_ref, :text
    change_column :vms, :ems_ref, :text
  end
end
