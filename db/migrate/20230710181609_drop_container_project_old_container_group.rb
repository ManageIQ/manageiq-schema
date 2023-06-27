class DropContainerProjectOldContainerGroup < ActiveRecord::Migration[6.1]
  def change
    remove_column :container_groups, :old_container_project_id, :bigint
  end
end
