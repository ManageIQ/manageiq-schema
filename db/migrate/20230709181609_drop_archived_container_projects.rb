class DropArchivedContainerProjects < ActiveRecord::Migration[6.1]
  class ContainerGroup < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    ContainerGroup.where.not(:old_container_project_id => nil)
                  .where(:container_project_id => nil)
                  .update_all('container_project_id = old_container_project_id')
  end

  def down
    # Sorry. No down available (but not a problem)

    # The new format (with container_project_id assigned)
    # is valid before and after this migration and has been for years.
  end
end
