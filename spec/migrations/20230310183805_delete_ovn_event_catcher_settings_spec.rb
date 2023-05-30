require_migration

describe DeleteOvnEventCatcherSettings do
  let(:settings_change_stub) { migration_stub(:SettingsChange) }

  migration_context :up do
    it "Deletes Ovirt network event catcher settings" do
      settings_change_stub.create(:key => "/workers/worker_base/event_catcher/event_catcher_ovirt_network/poll", :value => "30.seconds")
      migrate
      expect(settings_change_stub.count).to be_zero
    end

    it "Deletes RHV network event catcher settings" do
      settings_change_stub.create(:key => "/workers/worker_base/event_catcher/event_catcher_redhat_network/poll", :value => "30.seconds")
      migrate
      expect(settings_change_stub.count).to be_zero
    end

    it "Doesn't impact unrelated settings" do
      settings_change_stub.create(:key => "/workers/worker_base/event_catcher/event_catcher_openstack_network/poll", :value => "30.seconds")
      migrate
      expect(settings_change_stub.count).to eq(1)
    end
  end
end
