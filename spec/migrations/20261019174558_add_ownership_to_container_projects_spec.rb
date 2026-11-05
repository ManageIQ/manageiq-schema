require_migration

describe AddOwnershipToContainerProjects do
  let(:container_project_stub) { new_migration_stub(:container_projects) }

  migration_context :up do
    it "adds evm_owner_id, miq_group_id, and tenant_id columns" do
      record = container_project_stub.create!
      expect(record.respond_to?(:evm_owner_id)).to be false
      expect(record.respond_to?(:miq_group_id)).to be false
      expect(record.respond_to?(:tenant_id)).to be false

      migrate

      record.reload
      expect(record.respond_to?(:evm_owner_id)).to be true
      expect(record.respond_to?(:miq_group_id)).to be true
      expect(record.respond_to?(:tenant_id)).to be true
    end
  end

  migration_context :down do
    it "removes evm_owner_id, miq_group_id, and tenant_id columns" do
      record = container_project_stub.create!
      expect(record.respond_to?(:evm_owner_id)).to be true
      expect(record.respond_to?(:miq_group_id)).to be true
      expect(record.respond_to?(:tenant_id)).to be true

      migrate

      record.reload
      expect(record.respond_to?(:evm_owner_id)).to be false
      expect(record.respond_to?(:miq_group_id)).to be false
      expect(record.respond_to?(:tenant_id)).to be false
    end
  end
end
