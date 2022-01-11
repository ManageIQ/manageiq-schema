require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe FixIbmCloudStiClasses do
  let(:ems_stub)                          { migration_stub(:ExtManagementSystem) }
  let(:availabiity_zone_stub)             { migration_stub(:AvailabilityZone) }
  let(:flavor_stub)                       { migration_stub(:Flavor) }
  let(:load_balancer_stub)                { migration_stub(:LoadBalancer) }
  let(:network_port_stub)                 { migration_stub(:NetworkPort) }
  let(:cloud_object_store_container_stub) { migration_stub(:CloudObjectStoreContainer) }
  let(:cloud_object_store_object_stub)    { migration_stub(:CloudObjectStoreObject) }

  migration_context :up do
    it "Fixes IBM Power Cloud STI classes" do
      power_cloud   = ems_stub.create(:type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager")
      power_network = ems_stub.create(:type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::NetworkManager")

      availabiity_zone = availabiity_zone_stub.create(:ext_management_system => power_cloud)
      flavor           = flavor_stub.create(:ext_management_system => power_cloud)
      load_balancer    = load_balancer_stub.create(:ext_management_system => power_network)

      migrate

      expect(availabiity_zone.reload.type).to eq("ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::AvailabilityZone")
      expect(flavor.reload.type).to           eq("ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Flavor")
      expect(load_balancer.reload.type).to    eq("ManageIQ::Providers::IbmCloud::PowerVirtualServers::NetworkManager::LoadBalancer")
    end

    it "Fixes IBM VPC STI classes" do
      vpc_network = ems_stub.create(:type => "ManageIQ::Providers::IbmCloud::VPC::NetworkManager")

      network_port = network_port_stub.create(:ext_management_system => vpc_network)

      migrate

      expect(network_port.reload.type).to eq("ManageIQ::Providers::IbmCloud::VPC::NetworkManager::NetworkPort")
    end

    it "Fixes IBM Cloud Object Storage" do
      ibm_object_storage = ems_stub.create(:type => "ManageIQ::Providers::IbmCloud::ObjectStorage::StorageManager")

      cloud_object_store_container = cloud_object_store_container_stub.create(:ext_management_system => ibm_object_storage)
      cloud_object_store_object    = cloud_object_store_object_stub.create(:ext_management_system => ibm_object_storage)

      migrate

      expect(cloud_object_store_container.reload.type).to eq("ManageIQ::Providers::IbmCloud::ObjectStorage::StorageManager::CloudObjectStoreContainer")
      expect(cloud_object_store_object.reload.type).to    eq("ManageIQ::Providers::IbmCloud::ObjectStorage::StorageManager::CloudObjectStoreObject")
    end
  end

  migration_context :down do
    it "Resets IBM Power Cloud STI classes" do
      power_cloud   = ems_stub.create(:type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager")
      power_network = ems_stub.create(:type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::NetworkManager")

      availabiity_zone = availabiity_zone_stub.create(:ext_management_system => power_cloud, :type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::AvailabilityZone")
      flavor           = flavor_stub.create(:ext_management_system => power_cloud, :type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Flavor")
      load_balancer    = load_balancer_stub.create(:ext_management_system => power_network, :type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::NetworkManager::LoadBalancer")

      migrate

      expect(availabiity_zone.reload.type).to be_nil
      expect(flavor.reload.type).to           be_nil
      expect(load_balancer.reload.type).to    be_nil
    end

    it "Resets IBM VPC STI Classes" do
      vpc_network = ems_stub.create(:type => "ManageIQ::Providers::IbmCloud::VPC::NetworkManager")

      network_port = network_port_stub.create(:ext_management_system => vpc_network, :type => "ManageIQ::Providers::IbmCloud::VPC::NetworkManager::NetworkPort")

      migrate

      expect(network_port.reload.type).to be_nil
    end

    it "Resets IBM Cloud Object Storage" do
      ibm_object_storage = ems_stub.create(:type => "ManageIQ::Providers::IbmCloud::ObjectStorage::StorageManager")

      cloud_object_store_container = cloud_object_store_container_stub.create(:ext_management_system => ibm_object_storage, :type => "ManageIQ::Providers::IbmCloud::ObjectStorage::StorageManager::CloudObjectStoreContainer")
      cloud_object_store_object    = cloud_object_store_object_stub.create(:ext_management_system => ibm_object_storage, :type => "ManageIQ::Providers::IbmCloud::ObjectStorage::StorageManager::CloudObjectStoreObject")

      migrate

      expect(cloud_object_store_container.reload.type).to be_nil
      expect(cloud_object_store_object.reload.type).to    be_nil
    end
  end
end
