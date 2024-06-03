require_migration

RSpec.describe FixGoogleCloudVolumeSti do
  let(:ems_stub)    { migration_stub(:ExtManagementSystem) }
  let(:volume_stub) { migration_stub(:CloudVolume) }

  migration_context :up do
    it "Fixes the STI class of Google Cloud Volumes" do
      gce = ems_stub.create!(:type => "ManageIQ::Providers::Google::CloudManager")
      volume = volume_stub.create!(:ems_id => gce.id, :type => nil)

      migrate

      expect(volume.reload.type).to eq("ManageIQ::Providers::Google::CloudManager::CloudVolume")
    end

    it "Doesn't impact non-Google Cloud volumes" do
      osp = ems_stub.create!(:type => "ManageIQ::Providers::Openstack::CloudManager")
      volume = volume_stub.create!(
        :ems_id => osp.id,
        :type                  => "ManageIQ::Providers::Openstack::CloudManager::CloudVolume"
      )

      migrate

      expect(volume.reload.type).to eq("ManageIQ::Providers::Openstack::CloudManager::CloudVolume")
    end
  end

  migration_context :down do
    it "Fixes the STI class of Google Cloud Volumes" do
      gce = ems_stub.create!(:type => "ManageIQ::Providers::Google::CloudManager")
      volume = volume_stub.create!(
        :ems_id => gce.id,
        :type                  => "ManageIQ::Providers::Google::CloudManager::CloudVolume"
      )

      migrate

      expect(volume.reload.type).to be_nil
    end

    it "Doesn't impact non-Google Cloud volumes" do
      osp = ems_stub.create!(:type => "ManageIQ::Providers::Openstack::CloudManager")
      volume = volume_stub.create!(
        :ems_id => osp.id,
        :type                  => "ManageIQ::Providers::Openstack::CloudManager::CloudVolume"
      )

      migrate

      expect(volume.reload.type).to eq("ManageIQ::Providers::Openstack::CloudManager::CloudVolume")
    end
  end
end
