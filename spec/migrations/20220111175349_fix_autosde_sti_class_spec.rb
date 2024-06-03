require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe FixAutosdeStiClass do
  let(:ems_stub)              { migration_stub(:ExtManagementSystem) }
  let(:storage_resource_stub) { migration_stub(:StorageResource) }
  let(:storage_service_stub)  { migration_stub(:StorageService) }

  migration_context :up do
    it "fixes AutoSDE class names" do
      autosde = ems_stub.create(:type => "ManageIQ::Providers::Autosde::StorageManager")
      storage_resource = storage_resource_stub.create(:ems_id => autosde.id)
      storage_service = storage_service_stub.create(:ems_id => autosde.id)

      migrate

      expect(storage_resource.reload.type).to eq("ManageIQ::Providers::Autosde::StorageManager::StorageResource")
      expect(storage_service.reload.type).to eq("ManageIQ::Providers::Autosde::StorageManager::StorageService")
    end
  end

  migration_context :down do
    it "resets AutoSDE class names" do
      autosde = ems_stub.create(:type => "ManageIQ::Providers::Autosde::StorageManager")
      storage_resource = storage_resource_stub.create(:ems_id => autosde.id, :type => "ManageIQ::Providers::Autosde::StorageManager::StorageResource")
      storage_service = storage_service_stub.create(:ems_id => autosde.id, :type => "ManageIQ::Providers::Autosde::StorageManager::StorageService")

      migrate

      expect(storage_resource.reload.type).to be_nil
      expect(storage_service.reload.type).to be_nil
    end
  end
end
