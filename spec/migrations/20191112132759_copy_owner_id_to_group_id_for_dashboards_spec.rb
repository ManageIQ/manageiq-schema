require_migration

describe CopyOwnerIdToGroupIdForDashboards do
  let(:miq_set)          { migration_stub(:MiqSet) }
  let(:name)             { "Hello Dashboard" }
  let(:group_id)         { 1 }

  migration_context :up do
    it "Copying owner_id to group_id in miq_sets table for each dashboard assigned to group only" do
      dashboard = miq_set.create!(:name => name, :set_type => "MiqWidgetSet", :owner_type => "MiqGroup", :owner_id => group_id)
      policy_set = miq_set.create!(:name => name, :set_type => "MiqPolicySet", :owner_id => group_id)

      migrate

      expect(dashboard.reload.group_id).to eq(group_id)
      expect(policy_set.reload.group_id).to be nil
    end
  end

  migration_context :down do
    it "Nullifying group_id column in miq_sets table for each dashboard assigned to group" do
      dashboard = miq_set.create!(:name => name, :set_type => "MiqWidgetSet", :owner_type => "MiqGroup", :group_id => group_id)
      policy_set = miq_set.create!(:name => name, :set_type => "MiqPolicySet", :group_id => group_id)

      migrate

      expect(dashboard.reload.group_id).to be nil
      expect(policy_set.reload.group_id).to eq(group_id)
    end
  end
end
