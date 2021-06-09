require_migration

RSpec.describe FixRedhatNetworkManagerStiType do
  let(:ems_stub)            { migration_stub(:ExtManagementSystem) }
  let(:cloud_network_stub)  { migration_stub(:CloudNetwork) }
  let(:cloud_subnet_stub)   { migration_stub(:CloudSubnet) }
  let(:floating_ip_stub)    { migration_stub(:FloatingIp) }
  let(:network_port_stub)   { migration_stub(:NetworkPort) }
  let(:network_router_stub) { migration_stub(:NetworkRouter) }
  let(:security_group_stub) { migration_stub(:SecurityGroup) }

  migration_context :up do
    it "Fixes the Ovirt NetworkManager inventory classes" do
      redhat_network_manager = ems_stub.create!(:type => "ManageIQ::Providers::Redhat::NetworkManager")
      cloud_network          = cloud_network_stub.create!(:ems_id => redhat_network_manager.id, :type => "ManageIQ::Providers::Openstack::NetworkManager::CloudNetwork")
      cloud_network_public   = cloud_network_stub.create!(:ems_id => redhat_network_manager.id, :type => "ManageIQ::Providers::Openstack::NetworkManager::CloudNetwork::Public")
      cloud_network_private  = cloud_network_stub.create!(:ems_id => redhat_network_manager.id, :type => "ManageIQ::Providers::Openstack::NetworkManager::CloudNetwork::Private")
      cloud_subnet           = cloud_subnet_stub.create!(:ems_id => redhat_network_manager.id, :type => "ManageIQ::Providers::Openstack::NetworkManager::CloudSubnet")
      floating_ip            = floating_ip_stub.create!(:ems_id => redhat_network_manager.id, :type => "ManageIQ::Providers::Openstack::NetworkManager::FloatingIp")
      network_port           = network_port_stub.create!(:ems_id => redhat_network_manager.id, :type => "ManageIQ::Providers::Openstack::NetworkManager::NetworkPort")
      network_router         = network_router_stub.create!(:ems_id => redhat_network_manager.id, :type => "ManageIQ::Providers::Openstack::NetworkManager::NetworkRouter")
      security_group         = security_group_stub.create!(:ems_id => redhat_network_manager.id, :type => "ManageIQ::Providers::Openstack::NetworkManager::SecurityGroup")

      migrate

      expect(cloud_network.reload.type).to eq("ManageIQ::Providers::Redhat::NetworkManager::CloudNetwork")
      expect(cloud_network_public.reload.type).to eq("ManageIQ::Providers::Redhat::NetworkManager::CloudNetwork::Public")
      expect(cloud_network_private.reload.type).to eq("ManageIQ::Providers::Redhat::NetworkManager::CloudNetwork::Private")
      expect(cloud_subnet.reload.type).to eq("ManageIQ::Providers::Redhat::NetworkManager::CloudSubnet")
      expect(floating_ip.reload.type).to eq("ManageIQ::Providers::Redhat::NetworkManager::FloatingIp")
      expect(network_port.reload.type).to eq("ManageIQ::Providers::Redhat::NetworkManager::NetworkPort")
      expect(network_router.reload.type).to eq("ManageIQ::Providers::Redhat::NetworkManager::NetworkRouter")
      expect(security_group.reload.type).to eq("ManageIQ::Providers::Redhat::NetworkManager::SecurityGroup")
    end
  end

  migration_context :down do
    it "Reverts the Ovirt NetworkManager inventory classes" do
      redhat_network_manager = ems_stub.create!(:type => "ManageIQ::Providers::Redhat::NetworkManager")
      cloud_network          = cloud_network_stub.create!(:ems_id => redhat_network_manager.id, :type => "ManageIQ::Providers::Redhat::NetworkManager::CloudNetwork")
      cloud_network_public   = cloud_network_stub.create!(:ems_id => redhat_network_manager.id, :type => "ManageIQ::Providers::Redhat::NetworkManager::CloudNetwork::Public")
      cloud_network_private  = cloud_network_stub.create!(:ems_id => redhat_network_manager.id, :type => "ManageIQ::Providers::Redhat::NetworkManager::CloudNetwork::Private")
      cloud_subnet           = cloud_subnet_stub.create!(:ems_id => redhat_network_manager.id, :type => "ManageIQ::Providers::Redhat::NetworkManager::CloudSubnet")
      floating_ip            = floating_ip_stub.create!(:ems_id => redhat_network_manager.id, :type => "ManageIQ::Providers::Redhat::NetworkManager::FloatingIp")
      network_port           = network_port_stub.create!(:ems_id => redhat_network_manager.id, :type => "ManageIQ::Providers::Redhat::NetworkManager::NetworkPort")
      network_router         = network_router_stub.create!(:ems_id => redhat_network_manager.id, :type => "ManageIQ::Providers::Redhat::NetworkManager::NetworkRouter")
      security_group         = security_group_stub.create!(:ems_id => redhat_network_manager.id, :type => "ManageIQ::Providers::Redhat::NetworkManager::SecurityGroup")

      migrate

      expect(cloud_network.reload.type).to eq("ManageIQ::Providers::Openstack::NetworkManager::CloudNetwork")
      expect(cloud_network_public.reload.type).to eq("ManageIQ::Providers::Openstack::NetworkManager::CloudNetwork::Public")
      expect(cloud_network_private.reload.type).to eq("ManageIQ::Providers::Openstack::NetworkManager::CloudNetwork::Private")
      expect(cloud_subnet.reload.type).to eq("ManageIQ::Providers::Openstack::NetworkManager::CloudSubnet")
      expect(floating_ip.reload.type).to eq("ManageIQ::Providers::Openstack::NetworkManager::FloatingIp")
      expect(network_port.reload.type).to eq("ManageIQ::Providers::Openstack::NetworkManager::NetworkPort")
      expect(network_router.reload.type).to eq("ManageIQ::Providers::Openstack::NetworkManager::NetworkRouter")
      expect(security_group.reload.type).to eq("ManageIQ::Providers::Openstack::NetworkManager::SecurityGroup")
    end
  end
end
