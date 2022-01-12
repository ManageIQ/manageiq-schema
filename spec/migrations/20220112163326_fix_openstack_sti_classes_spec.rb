require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe FixOpenstackStiClasses do
  let(:ems_stub)                          { migration_stub(:ExtManagementSystem) }
  let(:cloud_volume_stub)                 { migration_stub(:CloudVolume) }
  let(:cloud_volume_snapshot_stub)        { migration_stub(:CloudVolumeSnapshot) }
  let(:cloud_volume_type_stub)            { migration_stub(:CloudVolumeType) }
  let(:cloud_volume_backup_stub)          { migration_stub(:CloudVolumeBackup) }
  let(:cloud_object_store_container_stub) { migration_stub(:CloudObjectStoreContainer) }
  let(:cloud_object_store_object_stub)    { migration_stub(:CloudObjectStoreObject) }

  migration_context :up do
    it "Fixes Openstack Cinder/Swift STI classes" do
      cinder = ems_stub.create(:type => "ManageIQ::Providers::Openstack::StorageManager::CinderManager")
      swift  = ems_stub.create(:type => "ManageIQ::Providers::Openstack::StorageManager::SwiftManager")

      cloud_volume          = cloud_volume_stub.create(:ext_management_system => cinder)
      cloud_volume_snapshot = cloud_volume_snapshot_stub.create(:ext_management_system => cinder)
      cloud_volume_type     = cloud_volume_type_stub.create(:ext_management_system => cinder)
      cloud_volume_backup   = cloud_volume_backup_stub.create(:ext_management_system => cinder)

      cloud_object_store_object    = cloud_object_store_object_stub.create(:ext_management_system => swift)
      cloud_object_store_container = cloud_object_store_container_stub.create(:ext_management_system => swift)

      migrate

      expect(cloud_volume.reload.type).to          eq("ManageIQ::Providers::Openstack::StorageManager::CinderManager::CloudVolume")
      expect(cloud_volume_snapshot.reload.type).to eq("ManageIQ::Providers::Openstack::StorageManager::CinderManager::CloudVolumeSnapshot")
      expect(cloud_volume_type.reload.type).to     eq("ManageIQ::Providers::Openstack::StorageManager::CinderManager::CloudVolumeType")
      expect(cloud_volume_backup.reload.type).to   eq("ManageIQ::Providers::Openstack::StorageManager::CinderManager::CloudVolumeBackup")

      expect(cloud_object_store_object.reload.type).to    eq("ManageIQ::Providers::Openstack::StorageManager::SwiftManager::CloudObjectStoreObject")
      expect(cloud_object_store_container.reload.type).to eq("ManageIQ::Providers::Openstack::StorageManager::SwiftManager::CloudObjectStoreContainer")
    end
  end

  migration_context :down do
    it "Resets Openstack Cinder/Swift classes" do
      cinder = ems_stub.create(:type => "ManageIQ::Providers::Openstack::StorageManager::CinderManager")
      swift  = ems_stub.create(:type => "ManageIQ::Providers::Openstack::StorageManager::SwiftManager")

      cloud_volume          = cloud_volume_stub.create(:ext_management_system => cinder, :type => "ManageIQ::Providers::Openstack::StorageManager::CinderManager::CloudVolume")
      cloud_volume_snapshot = cloud_volume_snapshot_stub.create(:ext_management_system => cinder, :type => "ManageIQ::Providers::Openstack::StorageManager::CinderManager::CloudVolumeSnapshot")
      cloud_volume_type     = cloud_volume_type_stub.create(:ext_management_system => cinder, :type => "ManageIQ::Providers::Openstack::StorageManager::CinderManager::CloudVolumeType")
      cloud_volume_backup   = cloud_volume_backup_stub.create(:ext_management_system => cinder, :type => "ManageIQ::Providers::Openstack::StorageManager::CinderManager::CloudVolumeBackup")

      cloud_object_store_object    = cloud_object_store_object_stub.create(:ext_management_system => swift, :type => "ManageIQ::Providers::Openstack::StorageManager::SwiftManager::CloudObjectStoreObject")
      cloud_object_store_container = cloud_object_store_container_stub.create(:ext_management_system => swift, :type => "ManageIQ::Providers::Openstack::StorageManager::SwiftManager::CloudObjectStoreContainer")

      migrate

      expect(cloud_volume.reload.type).to          be_nil
      expect(cloud_volume_snapshot.reload.type).to be_nil
      expect(cloud_volume_type.reload.type).to     be_nil
      expect(cloud_volume_backup.reload.type).to   be_nil

      expect(cloud_object_store_object.reload.type).to    be_nil
      expect(cloud_object_store_container.reload.type).to be_nil
    end
  end
end
