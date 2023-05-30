require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe MoveConcurrentRequestsSettingsToVmware do
  let(:settings_change) { migration_stub(:SettingsChange) }

  migration_context :up do
    it "moves global concurrent_requests to vmware" do
      record1 = settings_change.create!(:key => "/performance/concurrent_requests/realtime", :value => '250')
      record2 = settings_change.create!(:key => "/performance/concurrent_requests/historical", :value => '250')
      record3 = settings_change.create!(:key => "/other/key", :value => 'x')
      migrate
      expect(record1.reload.key).to eq("/ems/ems_vmware/concurrent_requests/realtime")
      expect(record2.reload.key).to eq("/ems/ems_vmware/concurrent_requests/historical")
      expect(record3.reload.key).to eq("/other/key")
    end
  end

  migration_context :down do
    it "moves concurrent_requests back to global settings" do
      record1 = settings_change.create!(:key => "/ems/ems_vmware/concurrent_requests/realtime", :value => '250')
      record2 = settings_change.create!(:key => "/ems/ems_vmware/concurrent_requests/historical", :value => '250')
      record3 = settings_change.create!(:key => "/other/key", :value => 'x')
      migrate
      expect(record1.reload.key).to eq("/performance/concurrent_requests/realtime")
      expect(record2.reload.key).to eq("/performance/concurrent_requests/historical")
      expect(record3.reload.key).to eq("/other/key")
    end
  end
end
