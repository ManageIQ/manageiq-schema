class ContainerIndexes < ActiveRecord::Migration[6.1]
  def change
    # container projects page
    add_index :container_routes, :container_project_id
    add_index :container_services, :container_project_id
    # didn't show much, since only had 1 record
    add_index :container_replicators, :container_project_id

    add_index :container_groups, [:container_project_id, :id], :name => "index_container_groups_on_cpid_id_not_del", :where => "deleted_on IS NULL"
    # container providers screen

    # NOTE: this gets index only scans, but has a larger index size
    add_index :taggings, [:taggable_type, :taggable_id, :tag_id], :name => "index_taggings_on_type_id_id"
    remove_index :taggings, :column => [:taggable_id, :taggable_type], :name => "index_taggings_on_taggable_id_and_taggable_type"

    # container Services
    add_index :container_groups_container_services, [:container_service_id, :container_group_id], :name => "index_container_groups_on_csi_cgi"

    # container groups
    add_index :containers, [:container_group_id, :state]

    # container nodes
    add_index :container_conditions, [:container_entity_type, :container_entity_id, :name], :name => "index_container_conditions_on_cet_ceid_name"
  end
end
