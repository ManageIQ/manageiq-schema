require_migration

describe RemoveGoogleNetworkRefreshWorkers do
  migration_context :up do
    let(:miq_worker) { migration_stub(:MiqWorker) }

    it "deletes Google NetworkManager RefreshWorker workers" do
      miq_worker.create!(:type => "MiqWorker")
      miq_worker.create!(:type => "ManageIQ::Providers::Google::NetworkManager::RefreshWorker")

      migrate

      expect(miq_worker.count).to      eq(1)
      expect(miq_worker.first.type).to eq("MiqWorker")
    end
  end
end
