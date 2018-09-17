class DropDuplicateIndexes < ActiveRecord::Migration[5.0]
  def change
    # existing: index_cloud_subnets_network_ports_address (cloud_subnet_id, network_port_id, address)
    remove_index :cloud_subnets_network_ports,
                 :column => "cloud_subnet_id"

    # wrong index
    # existing: configuration_profiles_configuration_tags_profile_id (configuration_profile_id)
    remove_index :configuration_profiles_configuration_tags,
                 :column => :configuration_profile_id,
                 :name   => "index_direct_configuration_profiles_tags_profile_id"

    # existing: configuration_profiles_configuration_tags_tag_id (configuration_tag_id)
    remove_index :configuration_profiles_configuration_tags,
                 :column => :configuration_tag_id,
                 :name   => "index_direct_configuration_profiles_tags_tag_id"

    # intended indexes:
    add_index :direct_configuration_profiles_configuration_tags,
              :configuration_profile_id,
              :name => "index_direct_configuration_profiles_tags_profile_id"

    # intended indexes:
    add_index :direct_configuration_profiles_configuration_tags,
              :configuration_tag_id,
              :name => "index_direct_configuration_profiles_tags_tag_id"

    # existing: load_balancer_health_check_members_index (load_balancer_health_check_id, load_balancer_pool_member_id)
    remove_index :load_balancer_health_check_members,
                 :column => :load_balancer_health_check_id,
                 :name   => "members_load_balancer_health_check_index"

    # existing: load_balancer_listener_pools_index (load_balancer_listener_id, load_balancer_pool_id)
    remove_index :load_balancer_listener_pools,
                 :column => :load_balancer_listener_id

    # existing: load_balancer_pool_member_pools_index (load_balancer_pool_id, load_balancer_pool_member_id)
    remove_index :load_balancer_pool_member_pools,
                 :column => :load_balancer_pool_id,
                 :name   => "load_balancer_pool_index"
  end
end
