require_migration

describe MigrateConditionsTowHatToResourceType do
  let(:condition_stub) { migration_stub(:Condition) }

  migration_context :up do
    it "converts the old data" do
      condition = condition_stub.create!(:towhat => "ContainerImage")

      migrate

      expect(condition.reload.resource_type).to eq("ContainerImage")
    end

    it "ignores already converted data" do
      condition = condition_stub.create!(:towhat => "ContainerImage")

      migrate

      expect(condition.reload.resource_type).to eq("ContainerImage")
    end
  end
end
