require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe FixOracleCloudStiClasses do
  let(:ems_stub)           { migration_stub(:ExtManagementSystem) }
  let(:cloud_tenant_stub)  { migration_stub(:CloudTenant) }
  let(:load_balancer_stub) { migration_stub(:LoadBalancer) }

  migration_context :up do
    it "Fixes OracleCloud STI classes" do
      oracle_cloud   = ems_stub.create(:type => "ManageIQ::Providers::OracleCloud::CloudManager")
      oracle_network = ems_stub.create(:type => "ManageIQ::Providers::OracleCloud::NetworkManager")

      cloud_tenant  = cloud_tenant_stub.create(:ext_management_system => oracle_cloud)
      load_balancer = load_balancer_stub.create(:ext_management_system => oracle_network)

      migrate

      expect(cloud_tenant.reload.type).to eq("ManageIQ::Providers::OracleCloud::CloudManager::CloudTenant")
      expect(load_balancer.reload.type).to eq("ManageIQ::Providers::OracleCloud::NetworkManager::LoadBalancer")
    end
  end

  migration_context :down do
    it "Resets OracleCloud STI classes" do
      oracle_cloud   = ems_stub.create(:type => "ManageIQ::Providers::OracleCloud::CloudManager")
      oracle_network = ems_stub.create(:type => "ManageIQ::Providers::OracleCloud::NetworkManager")

      cloud_tenant  = cloud_tenant_stub.create(:ext_management_system => oracle_cloud, :type => "ManageIQ::Providers::OracleCloud::CloudManager::CloudTenant")
      load_balancer = load_balancer_stub.create(:ext_management_system => oracle_network, :type => "ManageIQ::Providers::OracleCloud::NetworkManager::LoadBalancer")

      migrate

      expect(cloud_tenant.reload.type).to be_nil
      expect(load_balancer.reload.type).to be_nil
    end
  end
end
