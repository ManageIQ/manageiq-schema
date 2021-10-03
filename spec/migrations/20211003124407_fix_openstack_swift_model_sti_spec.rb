require_migration

describe FixOpenstackSwiftModelSti do
  let(:ems_stub)                          { migration_stub(:ExtManagementSystem) }
  let(:cloud_object_store_container_stub) { migration_stub(:CloudObjectStoreContainer) }
  let(:cloud_object_store_object_stub)    { migration_stub(:CloudObjectStoreObject) }

  migration_context :up do
    it "fixes OpenStack Swift models' STI class" do
      swift_manager = ems_stub.create(:type => "ManageIQ::Providers::Openstack::StorageManager::SwiftManager")

      cloud_object_store_container = cloud_object_store_container_stub.create(:ext_management_system => swift_manager, :type => nil)
      cloud_object_store_object    = cloud_object_store_object_stub.create(:ext_management_system => swift_manager, :type => nil)

      migrate

      expect(cloud_object_store_container.reload.type).to eq("ManageIQ::Providers::Openstack::StorageManager::SwiftManager::CloudObjectStoreContainer")
      expect(cloud_object_store_object.reload.type).to eq("ManageIQ::Providers::Openstack::StorageManager::SwiftManager::CloudObjectStoreObject")
    end
  end

  migration_context :down do
    it "resets OpenStack Swift models' STI class" do
      swift_manager = ems_stub.create(:type => "ManageIQ::Providers::Openstack::StorageManager::SwiftManager")

      cloud_object_store_container = cloud_object_store_container_stub.create(:ext_management_system => swift_manager, :type => "ManageIQ::Providers::Openstack::StorageManager::SwiftManager::CloudObjectStoreContainer")
      cloud_object_store_object    = cloud_object_store_object_stub.create(:ext_management_system => swift_manager, :type => "ManageIQ::Providers::Openstack::StorageManager::SwiftManager::CloudObjectStoreObject")

      migrate

      expect(cloud_object_store_container.reload.type).to be_nil
      expect(cloud_object_store_object.reload.type).to be_nil
    end
  end
end
