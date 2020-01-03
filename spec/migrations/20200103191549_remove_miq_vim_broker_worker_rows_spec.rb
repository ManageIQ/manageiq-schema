require_migration

describe RemoveMiqVimBrokerWorkerRows do
  migration_context :up do
    let(:miq_worker) { migration_stub(:MiqWorker) }

    it "deletes MiqVimBrokerWorker workers" do
      miq_worker.create!(:type => "MiqWorker")
      miq_worker.create!(:type => "MiqVimBrokerWorker")

      migrate

      expect(miq_worker.count).to      eq(1)
      expect(miq_worker.first.type).to eq("MiqWorker")
    end
  end
end
