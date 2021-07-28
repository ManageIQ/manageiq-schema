class RemoveOldEmsIdFromContainerTables < ActiveRecord::Migration[6.0]
  def change
    remove_column :containers,         :old_ems_id, :bigint
    remove_column :container_groups,   :old_ems_id, :bigint
    remove_column :container_images,   :old_ems_id, :bigint
    remove_column :container_nodes,    :old_ems_id, :bigint
    remove_column :container_projects, :old_ems_id, :bigint
  end
end
