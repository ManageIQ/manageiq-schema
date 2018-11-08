require_migration

describe MigrateMiqPolicyTowhatToResourceType do
  let(:miq_policy_stub) { migration_stub(:MiqPolicy) }

  migration_context :up do
    it "converts the old data" do
      miq_policy = miq_policy_stub.create!(:towhat => "ContainerImage")

      migrate

      expect(miq_policy.reload.resource_type).to eq("ContainerImage")
    end

    it "ignores already converted data" do
      miq_policy = miq_policy_stub.create!(:towhat => "ContainerImage")

      migrate

      expect(miq_policy.reload.resource_type).to eq("ContainerImage")
    end
  end
end
