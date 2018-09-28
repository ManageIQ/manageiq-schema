require_migration

describe FixDefaultTenantGroup do
  let(:tenant_stub) { migration_stub(:Tenant) }
  let(:group_stub)  { migration_stub(:MiqGroup) }
  let(:role_stub)   { migration_stub(:MiqUserRole) }
  let(:tenant_role) { role_stub.create!(:name => role_stub::DEFAULT_TENANT_ROLE_NAME) }

  migration_context :up do
    context "role exists" do
      before do
        tenant_role # make sure it exists
      end

      it "creates a new group" do
        g = group_stub.create!(:group_type => group_stub::USER_GROUP)
        t = tenant_stub.create!(:default_miq_group_id => g.id)
        expect(t.default_miq_group).not_to be_tenant_group

        migrate

        t.reload
        expect(t.default_miq_group).to be_tenant_group
      end

      it "keeps valid tenant groups" do
        t = tenant_stub.create!
        t.add_default_miq_group
        g_id = t.default_miq_group_id
        t.save

        migrate

        t.reload
        expect(t.default_miq_group_id).to eq(g_id)
      end
    end
  end
end
