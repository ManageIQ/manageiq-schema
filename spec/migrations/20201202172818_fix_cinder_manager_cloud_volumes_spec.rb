require_migration

RSpec.describe FixCinderManagerCloudVolumes do
  let(:cloud_volume_stub)          { migration_stub(:CloudVolume) }
  let(:cloud_volume_snapshot_stub) { migration_stub(:CloudVolumeSnapshot) }
  let(:cloud_volume_backup_stub)   { migration_stub(:CloudVolumeBackup) }
  let(:cloud_volume_type_stub)     { migration_stub(:CloudVolumeType) }

  migration_context :up do
    it "Fixes the STI class of OpenStack Cloud Volumes, Backups, Snapshots, and Types" do
      cloud_volume = cloud_volume_stub.create!(
        :type => "ManageIQ::Providers::Openstack::CloudManager::CloudVolume"
      )
      cloud_volume_snapshot = cloud_volume_snapshot_stub.create!(
        :type => "ManageIQ::Providers::Openstack::CloudManager::CloudVolumeSnapshot"
      )
      cloud_volume_backup = cloud_volume_backup_stub.create!(
        :type => "ManageIQ::Providers::Openstack::CloudManager::CloudVolumeBackup"
      )
      cloud_volume_type = cloud_volume_type_stub.create!(
        :type => "ManageIQ::Providers::Openstack::CloudManager::CloudVolumeType"
      )

      migrate

      expect(cloud_volume.reload.type).to eq("ManageIQ::Providers::Openstack::StorageManager::CinderManager::CloudVolume")
      expect(cloud_volume_snapshot.reload.type).to eq("ManageIQ::Providers::Openstack::StorageManager::CinderManager::CloudVolumeSnapshot")
      expect(cloud_volume_backup.reload.type).to eq("ManageIQ::Providers::Openstack::StorageManager::CinderManager::CloudVolumeBackup")
      expect(cloud_volume_type.reload.type).to eq("ManageIQ::Providers::Openstack::StorageManager::CinderManager::CloudVolumeType")
    end
  end

  migration_context :down do
    it "Resets the STI class of OpenStack Cloud Volumes, Backups, Snapshots, and Types" do
      cloud_volume = cloud_volume_stub.create!(
        :type => "ManageIQ::Providers::Openstack::StorageManager::CinderManager::CloudVolume"
      )
      cloud_volume_snapshot = cloud_volume_snapshot_stub.create!(
        :type => "ManageIQ::Providers::Openstack::StorageManager::CinderManager::CloudVolumeSnapshot"
      )
      cloud_volume_backup = cloud_volume_backup_stub.create!(
        :type => "ManageIQ::Providers::Openstack::StorageManager::CinderManager::CloudVolumeBackup"
      )
      cloud_volume_type = cloud_volume_type_stub.create!(
        :type => "ManageIQ::Providers::Openstack::StorageManager::CinderManager::CloudVolumeType"
      )

      migrate

      expect(cloud_volume.reload.type).to eq("ManageIQ::Providers::Openstack::CloudManager::CloudVolume")
      expect(cloud_volume_snapshot.reload.type).to eq("ManageIQ::Providers::Openstack::CloudManager::CloudVolumeSnapshot")
      expect(cloud_volume_backup.reload.type).to eq("ManageIQ::Providers::Openstack::CloudManager::CloudVolumeBackup")
      expect(cloud_volume_type.reload.type).to eq("ManageIQ::Providers::Openstack::CloudManager::CloudVolumeType")
    end
  end
end
