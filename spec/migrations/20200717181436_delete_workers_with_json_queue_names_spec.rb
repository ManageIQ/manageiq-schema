require_migration

describe DeleteWorkersWithJsonQueueNames do
  let(:miq_worker_stub) { migration_stub(:MiqWorker) }

  migration_context :up do
    it "deletes workers with a JSON type queue name" do
      worker = miq_worker_stub.create!(:queue_name => "[\"ems_4\", \"ems_5\", \"ems_6\"]")

      migrate

      expect(miq_worker_stub.find_by(:id => worker.id)).to be_nil
    end

    it "doesn't touch workers without JSON queue names" do
      worker = miq_worker_stub.create!(:queue_name => "ems_1")

      migrate

      expect(worker.reload.queue_name).to eq("ems_1")
    end
  end
end
