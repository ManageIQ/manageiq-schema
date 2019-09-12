require_migration

describe RemoveEmbeddedAnsibleWorkers do
  migration_context :up do
    let(:worker_stub) { migration_stub(:MiqWorker) }

    it "Removes rows where the model was deleted" do
      worker_stub.create!(:type => "EmbeddedAnsibleWorker")
      not_orphaned = worker_stub.create!

      expect(worker_stub.count).to eql 2

      migrate

      expect(worker_stub.first).to eql not_orphaned
      expect(worker_stub.count).to eql 1
    end
  end
end
