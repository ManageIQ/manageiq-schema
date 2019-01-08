require_migration

describe RemoveCinderManagerEventWorkerRows do
  migration_context :up do
    let(:miq_worker) { migration_stub(:MiqWorker) }

    it "deletes Openstack Cinder event workers" do
      miq_worker.create!(:type => "MiqWorker")
      miq_worker.create!(:type => "ManageIQ::Providers::StorageManager::CinderManager::EventCatcher")

      migrate

      expect(miq_worker.count).to      eq(1)
      expect(miq_worker.first.type).to eq("MiqWorker")
    end
  end
end
