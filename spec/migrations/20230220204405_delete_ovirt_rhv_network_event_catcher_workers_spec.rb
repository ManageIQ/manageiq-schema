require_migration

describe DeleteOvirtRhvNetworkEventCatcherWorkers do
  migration_context :up do
    let(:miq_worker) { migration_stub(:MiqWorker) }

    it "deletes Ovirt NetworkManager EventCatcher workers" do
      miq_worker.create!(:type => "ManageIQ::Providers::Ovirt::NetworkManager::EventCatcher")

      migrate

      expect(miq_worker.count).to eq(0)
    end

    it "deletes Redhat NetworkManager EventCatcher workers" do
      miq_worker.create!(:type => "ManageIQ::Providers::Redhat::NetworkManager::EventCatcher")

      migrate

      expect(miq_worker.count).to eq(0)
    end

    it "doesn't impact other workers" do
      miq_worker.create!(:type => "ManageIQ::Providers::Ovirt::NetworkManager::EventCatcher")
      miq_worker.create!(:type => "ManageIQ::Providers::Redhat::NetworkManager::EventCatcher")
      miq_worker.create!(:type => "ManageIQ::Providers::Redhat::InfraManager::EventCatcher")
      miq_worker.create!(:type => "MiqGenericWorker")

      migrate

      expect(miq_worker.count).to eq(2)
      expect(miq_worker.pluck(:type)).to match_array(%w[MiqGenericWorker ManageIQ::Providers::Redhat::InfraManager::EventCatcher])
    end
  end
end
