class AddTypeToContainerProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :container_projects, :type, :string
    add_index :container_projects, :type
  end
end
