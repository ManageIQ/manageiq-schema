class AddTypeToContainerProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :container_projects, :type, :string
  end
end
