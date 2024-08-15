require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe FixIbmPowerHmcHostStiClass do
  let(:ems_stub)   { migration_stub(:ExtManagementSystem) }
  let(:host_stub) { migration_stub(:Host) }

  migration_context :up do
    it "Fixes IBM Power HMC Host STI class" do
      hmc  = ems_stub.create(:type => "ManageIQ::Providers::IbmPowerHmc::InfraManager")
      host = host_stub.create(:ems_id => hmc.id)

      migrate

      expect(host.reload.type).to eq("ManageIQ::Providers::IbmPowerHmc::InfraManager::Host")
    end
  end

  migration_context :down do
    it "Resets IBM Power HMC Host STI class" do
      hmc  = ems_stub.create(:type => "ManageIQ::Providers::IbmPowerHmc::InfraManager")
      host = host_stub.create(:ems_id => hmc.id, :type => "ManageIQ::Providers::IbmPowerHmc::InfraManager::Host")

      migrate

      expect(host.reload.type).to be_nil
    end
  end
end
