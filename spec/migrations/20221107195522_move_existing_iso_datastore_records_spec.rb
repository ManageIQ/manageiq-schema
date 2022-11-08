require_migration

describe MoveExistingIsoDatastoreRecords do
  let(:ext_management_system_stub) { migration_stub(:ExtManagementSystem) }
  let(:datastore_stub) { migration_stub(:IsoDatastore) }
  let(:storage_stub) { migration_stub(:Storage) }
  let(:iso_image_stub) { migration_stub(:IsoImage) }

  migration_context :up do
    it "transfers datastore records to storages" do
      emss = %w[Ovirt Redhat].map do |vendor|
        ext_management_system_stub.create!(:type => "ManageIQ::Providers::#{vendor}::InfraManager")
      end

      emss.each { |ems| datastore_stub.create!(:ext_management_system => ems) }

      migrate

      storage_stub.all.each do |storage|
        expect(storage.reload.type).to eq("#{storage.ext_management_system.type}::IsoDatastore")
      end
    end

    it "transfers datastore records with iso images to storages" do
      emss = %w[Ovirt Redhat].map do |vendor|
        ext_management_system_stub.create!(:type => "ManageIQ::Providers::#{vendor}::InfraManager")
      end

      emss.each do |ems|
        datastore = datastore_stub.create!(:ext_management_system => ems)
        iso_image_stub.create!(:iso_datastore_id => datastore.id)
      end

      migrate

      storage_stub.all.each do |storage|
        expect(storage.reload.type).to eq("#{storage.ext_management_system.type}::IsoDatastore")
        expect(storage.iso_images.first.storage_id).to eq(storage.id)
      end
    end
  end

  migration_context :down do
    it "transfers eligible storage records to datastores" do
      storage = storage_stub.create!(:type => "ManageIQ::Providers::Ovirt::InfraManager::IsoDatastore")

      migrate

      datastore = datastore_stub.first
      expect(datastore).to have_attributes(:ems_id => storage.ems_id)
    end

    it "transfers eligible storage records with iso images to datastores" do
      storage = storage_stub.create!(:type => "ManageIQ::Providers::Ovirt::InfraManager::IsoDatastore")
      iso_image_stub.create!(:storage_id => storage.id)

      migrate

      datastore = datastore_stub.first
      iso_image = iso_image_stub.first
      expect(datastore).to have_attributes(:ems_id => storage.ems_id)
      expect(iso_image).to have_attributes(:iso_datastore_id => datastore.id)
    end
  end
end
