require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe FixKubevirtHostStorageStiClasses do
  let(:ems_stub)     { migration_stub(:ExtManagementSystem) }
  let(:host_stub)    { migration_stub(:Host) }
  let(:storage_stub) { migration_stub(:Storage) }

  migration_context :up do
    it "Fixes Kubevirt STI classes" do
      kubevirt = ems_stub.create(:type => "ManageIQ::Providers::Kubevirt::InfraManager")
      host     = host_stub.create(:ems_id => kubevirt.id)
      storage  = storage_stub.create(:ems_id => kubevirt.id)

      migrate

      expect(host.reload.type).to eq("ManageIQ::Providers::Kubevirt::InfraManager::Host")
      expect(storage.reload.type).to eq("ManageIQ::Providers::Kubevirt::InfraManager::Storage")
    end
  end

  migration_context :down do
    it "Resets Kubevirt STI classes" do
      kubevirt = ems_stub.create(:type => "ManageIQ::Providers::Kubevirt::InfraManager")
      host     = host_stub.create(:ems_id => kubevirt.id, :type => "ManageIQ::Providers::Kubevirt::InfraManager::Host")
      storage  = storage_stub.create(:ems_id => kubevirt.id, :type => "ManageIQ::Providers::Kubevirt::InfraManager::Storage")
      migrate

      expect(host.reload.type).to be_nil
      expect(storage.reload.type).to be_nil
    end
  end
end
