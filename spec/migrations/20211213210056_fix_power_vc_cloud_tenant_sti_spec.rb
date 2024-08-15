require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe FixPowerVcCloudTenantSti do
  let(:ems_stub)          { migration_stub(:ExtManagementSystem) }
  let(:cloud_tenant_stub) { migration_stub(:CloudTenant) }

  migration_context :up do
    it "fixes IbmPowerVc CloudTenant STI classes" do
      ibm_powervc_manager = ems_stub.create(:type => "ManageIQ::Providers::IbmPowerVc::CloudManager")
      cloud_tenant        = cloud_tenant_stub.create(:ems_id => ibm_powervc_manager.id, :type => "ManageIQ::Providers::Openstack::CloudManager::CloudTenant")

      migrate

      expect(cloud_tenant.reload.type).to eq("ManageIQ::Providers::IbmPowerVc::CloudManager::CloudTenant")
    end

    it "doesn't impact other CloudTenants" do
      awesome_cloud_manager = ems_stub.create(:type => "ManageIQ::Providers::AwesomeCloud::CloudManager")
      cloud_tenant          = cloud_tenant_stub.create(:ems_id => awesome_cloud_manager.id, :type => "ManageIQ::Providers::AwesomeCloud::CloudManager::CloudTenant")

      migrate

      expect(cloud_tenant.reload.type).to eq("ManageIQ::Providers::AwesomeCloud::CloudManager::CloudTenant")
    end
  end

  migration_context :down do
    it "resets IbmPowerVc CloudTenant STI classes" do
      ibm_powervc_manager = ems_stub.create(:type => "ManageIQ::Providers::IbmPowerVc::CloudManager")
      cloud_tenant        = cloud_tenant_stub.create(:ems_id => ibm_powervc_manager.id, :type => "ManageIQ::Providers::IbmPowerVc::CloudManager::CloudTenant")

      migrate

      expect(cloud_tenant.reload.type).to eq("ManageIQ::Providers::Openstack::CloudManager::CloudTenant")
    end

    it "doesn't impact other CloudTenants" do
      awesome_cloud_manager = ems_stub.create(:type => "ManageIQ::Providers::AwesomeCloud::CloudManager")
      cloud_tenant          = cloud_tenant_stub.create(:ems_id => awesome_cloud_manager.id, :type => "ManageIQ::Providers::AwesomeCloud::CloudManager::CloudTenant")

      migrate

      expect(cloud_tenant.reload.type).to eq("ManageIQ::Providers::AwesomeCloud::CloudManager::CloudTenant")
    end
  end
end
