require_migration

RSpec.describe SubclassSwiftManagerOpenstack do
  let(:ems_stub) { migration_stub(:ExtManagementSystem) }

  migration_context :up do
    it "Updates the SwiftManager :type" do
      ems = ems_stub.create!(:type => "ManageIQ::Providers::StorageManager::SwiftManager")

      migrate

      expect(ems.reload.type).to eq("ManageIQ::Providers::Openstack::StorageManager::SwiftManager")
    end

    it "Doesn't update other managers' types" do
      ems = ems_stub.create!(:type => "ManageIQ::Providers::StorageManager::CinderManager")

      migrate

      expect(ems.reload.type).to eq("ManageIQ::Providers::StorageManager::CinderManager")
    end
  end

  migration_context :down do
    it "Updates the SwiftManager :type" do
      ems = ems_stub.create!(:type => "ManageIQ::Providers::Openstack::StorageManager::SwiftManager")

      migrate

      expect(ems.reload.type).to eq("ManageIQ::Providers::StorageManager::SwiftManager")
    end

    it "Doesn't update other managers' types" do
      ems = ems_stub.create!(:type => "ManageIQ::Providers::StorageManager::CinderManager")

      migrate

      expect(ems.reload.type).to eq("ManageIQ::Providers::StorageManager::CinderManager")
    end
  end
end
