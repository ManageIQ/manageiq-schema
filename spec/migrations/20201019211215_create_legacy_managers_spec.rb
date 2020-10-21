require_migration

RSpec.describe CreateLegacyManagers do
  let(:os_provider_class)    { "ManageIQ::Providers::Openstack::CloudManager" }
  let(:cinder_ems_class)     { "ManageIQ::Providers::Openstack::StorageManager::CinderManager" }
  let(:swift_ems_class)      { "ManageIQ::Providers::StorageManager::SwiftManager" }

  let(:ems_stub)             { migration_stub(:ExtManagementSystem) }
  let(:volume_stub)          { migration_stub(:CloudVolume) }
  let(:backup_stub)          { migration_stub(:CloudVolumeBackup) }
  let(:snapshot_stub)        { migration_stub(:CloudVolumeSnapshot) }
  let(:store_container_stub) { migration_stub(:CloudObjectStoreContainer) }
  let(:store_object_stub)    { migration_stub(:CloudObjectStoreObject) }

  let(:provider) do
    ems_stub.create!(
      :type            => os_provider_class,
      :name            => "sample",
      :zone_id         => 99,
      :provider_region => "ne-dc1"
    )
  end

  # note: these are cached so if they are accessed before migrate, need to reload them
  let(:emses)          { ems_stub.order(:type).load }
  let(:cloud_manager)  { emses.first }
  let(:cinder_manager) { emses.second }
  let(:swift_manager)  { emses.last }

  migration_context :up do
    it "creates two managers for providers with no managers" do
      provider

      migrate

      expect(emses.count).to eq(3)

      expect(cinder_manager).to have_attributes(
        :type            => cinder_ems_class,
        :name            => /sample Cinder Manager/i,
        :zone_id         => 99,
        :parent_ems_id   => provider.id,
        :provider_region => "ne-dc1"
      )

      expect(swift_manager).to have_attributes(
        :type            => swift_ems_class,
        :name            => /sample swift manager/i,
        :zone_id         => 99,
        :parent_ems_id   => provider.id,
        :provider_region => "ne-dc1"
      )
    end

    it "migrates cinder objects" do
      provider
      volume_stub.create(:ems_id => provider.id)
      backup_stub.create(:ems_id => provider.id)
      snapshot_stub.create(:ems_id => provider.id)

      migrate

      expect(volume_stub.all.map(&:ems_id).uniq).to eq([cinder_manager.id])
      expect(backup_stub.all.map(&:ems_id).uniq).to eq([cinder_manager.id])
      expect(snapshot_stub.all.map(&:ems_id).uniq).to eq([cinder_manager.id])
    end

    it "migrates swift objects" do
      provider
      store_container_stub.create(:ems_id => provider.id)
      store_object_stub.create(:ems_id => provider.id)

      migrate

      expect(store_container_stub.all.map(&:ems_id).uniq).to eq([swift_manager.id])
      expect(store_object_stub.all.map(&:ems_id).uniq).to eq([swift_manager.id])
    end

    it "does not create cinder manager if it exists" do
      ems_stub.create!(
        :type            => cinder_ems_class,
        :name            => /sample Cinder/i,
        :zone_id         => 99,
        :parent_ems_id   => provider.id,
        :provider_region => "ne-dc1"
      )

      migrate

      expect(emses.count).to eq(3)
    end

    it "does not create swift manager if it exists" do
      ems_stub.create!(
        :type            => swift_ems_class,
        :name            => /sample swift/i,
        :zone_id         => 99,
        :parent_ems_id   => provider.id,
        :provider_region => "ne-dc1"
      )

      migrate

      expect(emses.count).to eq(3)
    end

    it "creates none if swift and cinder managers exist" do
      provider

      ems_stub.create!(
        :type            => cinder_ems_class,
        :name            => /sample Cinder/i,
        :zone_id         => 99,
        :parent_ems_id   => provider.id,
        :provider_region => "ne-dc1"
      )

      ems_stub.create!(
        :type            => swift_ems_class,
        :name            => /sample swift/i,
        :zone_id         => 99,
        :parent_ems_id   => provider.id,
        :provider_region => "ne-dc1"
      )

      migrate

      expect(emses.count).to eq(3)
    end
  end
end
