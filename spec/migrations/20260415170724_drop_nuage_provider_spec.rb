require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe DropNuageProvider do
  let(:cloud_network_stub)  { migration_stub(:CloudNetwork) }
  let(:cloud_subnet_stub)   { migration_stub(:CloudSubnet) }
  let(:cloud_tenant_stub)   { migration_stub(:CloudTenant) }
  let(:ems_stub)            { migration_stub(:ExtManagementSystem) }
  let(:floating_ip_stub)    { migration_stub(:FloatingIp) }
  let(:network_port_stub)   { migration_stub(:NetworkPort) }
  let(:network_router_stub) { migration_stub(:NetworkRouter) }
  let(:security_group_stub) { migration_stub(:SecurityGroup) }

  migration_context :up do
    it "Deletes all Nuage records" do
      nuage = ems_stub.create!(:type => "ManageIQ::Providers::Nuage::NetworkManager")
      cloud_network_stub.create!(:type => "ManageIQ::Providers::Nuage::NetworkManager::CloudNetwork", :ems_id => nuage.id)
      cloud_network_stub.create!(:type => "ManageIQ::Providers::Nuage::NetworkManager::CloudNetwork::Floating", :ems_id => nuage.id)
      cloud_subnet_stub.create!(:type => "ManageIQ::Providers::Nuage::NetworkManager::CloudSubnet", :ems_id => nuage.id)
      cloud_subnet_stub.create!(:type => "ManageIQ::Providers::Nuage::NetworkManager::CloudSubnet::L2", :ems_id => nuage.id)
      cloud_subnet_stub.create!(:type => "ManageIQ::Providers::Nuage::NetworkManager::CloudSubnet::L3", :ems_id => nuage.id)
      cloud_tenant_stub.create!(:type => "ManageIQ::Providers::Nuage::NetworkManager::CloudTenant", :ems_id => nuage.id)
      floating_ip_stub.create!(:type => "ManageIQ::Providers::Nuage::NetworkManager::FloatingIp", :ems_id => nuage.id)
      network_port_stub.create!(:type => "ManageIQ::Providers::Nuage::NetworkManager::NetworkPort", :ems_id => nuage.id)
      network_port_stub.create!(:type => "ManageIQ::Providers::Nuage::NetworkManager::NetworkPort::Bridge", :ems_id => nuage.id)
      network_port_stub.create!(:type => "ManageIQ::Providers::Nuage::NetworkManager::NetworkPort::Container", :ems_id => nuage.id)
      network_port_stub.create!(:type => "ManageIQ::Providers::Nuage::NetworkManager::NetworkPort::Host", :ems_id => nuage.id)
      network_port_stub.create!(:type => "ManageIQ::Providers::Nuage::NetworkManager::NetworkPort::Vm", :ems_id => nuage.id)
      network_router_stub.create!(:type => "ManageIQ::Providers::Nuage::NetworkManager::NetworkRouter", :ems_id => nuage.id)
      security_group_stub.create!(:type => "ManageIQ::Providers::Nuage::NetworkManager::SecurityGroup", :ems_id => nuage.id)

      migrate

      expect(ems_stub.count).to be_zero
      expect(cloud_network_stub.count).to be_zero
      expect(cloud_subnet_stub.count).to be_zero
      expect(cloud_tenant_stub.count).to be_zero
      expect(floating_ip_stub.count).to be_zero
      expect(network_port_stub.count).to be_zero
      expect(network_router_stub.count).to be_zero
      expect(security_group_stub.count).to be_zero
    end
  end
end
