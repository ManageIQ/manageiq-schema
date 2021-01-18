require_migration

RSpec.describe SubclassCinderManagerOpenstack do
  let(:ems_stub) { migration_stub(:ExtManagementSystem) }

  migration_context :up do
    it "Updates the CinderManager :type" do
      ems = ems_stub.create!(:type => "ManageIQ::Providers::StorageManager::CinderManager")

      migrate

      expect(ems.reload.type).to eq("ManageIQ::Providers::Openstack::StorageManager::CinderManager")
    end

    it "Doesn't update other managers' types" do
      ems = ems_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager")

      migrate

      expect(ems.reload.type).to eq("ManageIQ::Providers::Vmware::InfraManager")
    end
  end

  migration_context :down do
    it "Updates the CinderManager :type" do
      ems = ems_stub.create!(:type => "ManageIQ::Providers::Openstack::StorageManager::CinderManager")

      migrate

      expect(ems.reload.type).to eq("ManageIQ::Providers::StorageManager::CinderManager")
    end

    it "Doesn't update other managers' types" do
      ems = ems_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager")

      migrate

      expect(ems.reload.type).to eq("ManageIQ::Providers::Vmware::InfraManager")
    end
  end
end
