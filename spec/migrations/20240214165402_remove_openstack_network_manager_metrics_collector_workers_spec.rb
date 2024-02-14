require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe RemoveOpenstackNetworkManagerMetricsCollectorWorkers do
  let(:miq_worker) { migration_stub(:MiqWorker) }

  migration_context :up do
    it "deletes Openstack NetworkManager MetricsCollectorWorker workers" do
      miq_worker.create!(:type => "ManageIQ::Providers::Openstack::NetworkManager::MetricsCollectorWorker")

      migrate

      expect(miq_worker.count).to eq(0)
    end

    it "doesn't impact other workers" do
      miq_worker.create!(:type => "ManageIQ::Providers::Openstack::CloudManager::MetricsCollectorWorker")
      miq_worker.create!(:type => "ManageIQ::Providers::Vmware::InfraManager::MetricsCollectorWorker")

      migrate

      expect(miq_worker.count).to eq(2)
    end
  end
end
