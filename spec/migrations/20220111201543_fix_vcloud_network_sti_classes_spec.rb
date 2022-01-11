require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe FixVcloudNetworkStiClasses do
  let(:ems_stub)                        { migration_stub(:ExtManagementSystem) }
  let(:load_balancer_stub)              { migration_stub(:LoadBalancer) }
  let(:load_balancer_health_check_stub) { migration_stub(:LoadBalancerHealthCheck) }
  let(:load_balancer_listener_stub)     { migration_stub(:LoadBalancerListener) }
  let(:load_balancer_pool_stub)         { migration_stub(:LoadBalancerPool) }
  let(:load_balancer_pool_member_stub)  { migration_stub(:LoadBalancerPoolMember) }
  let(:security_group_stub)             { migration_stub(:SecurityGroup) }

  migration_context :up do
    it "Fixes vCloud Network STI classes" do
      vcloud_network = ems_stub.create(:type => "ManageIQ::Providers::Vmware::NetworkManager")

      load_balancer              = load_balancer_stub.create(:ext_management_system => vcloud_network)
      load_balancer_health_check = load_balancer_health_check_stub.create(:ext_management_system => vcloud_network)
      load_balancer_listener     = load_balancer_listener_stub.create(:ext_management_system => vcloud_network)
      load_balancer_pool         = load_balancer_pool_stub.create(:ext_management_system => vcloud_network)
      load_balancer_pool_member  = load_balancer_pool_member_stub.create(:ext_management_system => vcloud_network)
      secrity_group              = security_group_stub.create(:ext_management_system => vcloud_network)

      migrate

      expect(load_balancer.reload.type).to              eq("ManageIQ::Providers::Vmware::NetworkManager::LoadBalancer")
      expect(load_balancer_health_check.reload.type).to eq("ManageIQ::Providers::Vmware::NetworkManager::LoadBalancerHealthCheck")
      expect(load_balancer_listener.reload.type).to     eq("ManageIQ::Providers::Vmware::NetworkManager::LoadBalancerListener")
      expect(load_balancer_pool.reload.type).to         eq("ManageIQ::Providers::Vmware::NetworkManager::LoadBalancerPool")
      expect(load_balancer_pool_member.reload.type).to  eq("ManageIQ::Providers::Vmware::NetworkManager::LoadBalancerPoolMember")
      expect(secrity_group.reload.type).to              eq("ManageIQ::Providers::Vmware::NetworkManager::SecurityGroup")
    end
  end

  migration_context :down do
    it "Resets vCloud Network STI classes" do
      vcloud_network = ems_stub.create(:type => "ManageIQ::Providers::Vmware::NetworkManager")

      load_balancer              = load_balancer_stub.create(:ext_management_system => vcloud_network, :type => "ManageIQ::Providers::Vmware::NetworkManager::LoadBalancer")
      load_balancer_health_check = load_balancer_health_check_stub.create(:ext_management_system => vcloud_network, :type => "ManageIQ::Providers::Vmware::NetworkManager::LoadBalancerHealthCheck")
      load_balancer_listener     = load_balancer_listener_stub.create(:ext_management_system => vcloud_network, :type => "ManageIQ::Providers::Vmware::NetworkManager::LoadBalancerListener")
      load_balancer_pool         = load_balancer_pool_stub.create(:ext_management_system => vcloud_network, :type => "ManageIQ::Providers::Vmware::NetworkManager::LoadBalancerPool")
      load_balancer_pool_member  = load_balancer_pool_member_stub.create(:ext_management_system => vcloud_network, :type => "ManageIQ::Providers::Vmware::NetworkManager::LoadBalancerPoolMember")
      secrity_group              = security_group_stub.create(:ext_management_system => vcloud_network, :type => "ManageIQ::Providers::Vmware::NetworkManager::SecurityGroup")

      migrate

      expect(load_balancer.reload.type).to              be_nil
      expect(load_balancer_health_check.reload.type).to be_nil
      expect(load_balancer_listener.reload.type).to     be_nil
      expect(load_balancer_pool.reload.type).to         be_nil
      expect(load_balancer_pool_member.reload.type).to  be_nil
      expect(secrity_group.reload.type).to              be_nil
    end
  end
end
