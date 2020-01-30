require_migration

describe CopyCloudTenantsEmsRefToTenants do
  let(:cloud_tenant_model) { migration_stub(:CloudTenant) }
  let(:tenant_model)       { migration_stub(:Tenant) }
  let(:ems_model)          { migration_stub(:ExtManagementSystem) }
  let(:ems_guid)           { "XXXX" }
  let(:ems_ref)            { "YYYY" }

  migration_context :up do
    it "copies CloudTenant#ems_ref or ExtManagementSystem#guid to Tenant#ems_ref" do
      expect(ems_model.count).to eq(0)
      expect(cloud_tenant_model.count).to eq(0)

      ems = ems_model.create(:name => 'name', :guid => ems_guid)
      tenant_for_ems = tenant_model.create(:source_id => ems.id, :source_type => 'ExtManagementSystem')

      ct = cloud_tenant_model.create(:name => 'name', :ems_ref => ems_ref)
      tenant_for_cloud_tenant = tenant_model.create(:source_id => ct.id, :source_type => 'CloudTenant')

      migrate

      expect(tenant_for_ems.reload.ems_ref).to eq(ems_guid)
      expect(tenant_for_cloud_tenant.reload.ems_ref).to eq(ems_ref)
    end
  end

  migration_context :down do
    it "removes Tenant#ems_ref from Tenants with source" do
      ems = ems_model.create(:name => 'name', :guid => ems_guid)
      tenant_for_ems = tenant_model.create(:source_id => ems.id, :source_type => 'ExtManagementSystem', :ems_ref => ems_guid)

      ct = cloud_tenant_model.create(:name => 'name', :ems_ref => ems_ref)
      tenant_for_cloud_tenant = tenant_model.create(:source_id => ct.id, :source_type => 'CloudTenant', :ems_ref => ems_ref)

      migrate

      expect(tenant_for_ems.reload.ems_ref).to be_nil
      expect(tenant_for_cloud_tenant.reload.ems_ref).to be_nil
    end
  end
end
