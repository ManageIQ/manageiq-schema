require_migration

class DropArchivedContainerProjects
  class ContainerProject < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end
end

describe DropArchivedContainerProjects do
  let(:container_group_stub) { migration_stub(:ContainerGroup) }
  let(:container_project_stub) { migration_stub(:ContainerProject) }

  migration_context :up do
    it "reassigns container_project_ids" do
      cp_del_old = container_group_stub.create!(:deleted_on => Time.now.utc - 10.years)
      cp_del = container_group_stub.create!(:deleted_on => Time.now.utc)
      cp = container_group_stub.create!

      touched1  = container_group_stub.create!(:container_project_id => nil, :old_container_project_id => cp_del_old.id, :deleted_on => Time.now.utc)
      touched2  = container_group_stub.create!(:container_project_id => cp_del.id, :old_container_project_id => cp_del.id, :deleted_on => Time.now.utc)
      untouched = container_group_stub.create!(:container_project_id => cp.id)

      migrate

      expect(touched1.reload.container_project_id).to eq(cp_del_old.id)
      expect(touched2.reload.container_project_id).to eq(cp_del.id)
      expect(untouched.reload.container_project_id).to eq(cp.id)
    end
  end
end
