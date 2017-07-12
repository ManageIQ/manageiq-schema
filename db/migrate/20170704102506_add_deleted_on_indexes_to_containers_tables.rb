class AddDeletedOnIndexesToContainersTables < ActiveRecord::Migration[5.0]
  def change
    add_index :container_definitions, :deleted_on
    add_index :container_groups, :deleted_on
    add_index :container_images, :deleted_on
    add_index :container_projects, :deleted_on
    add_index :container_nodes, :deleted_on
    add_index :containers, :deleted_on
  end
end
