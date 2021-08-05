require_migration

describe RenameJobProxyDispatcherSettings do
  let(:settings_change_stub) { migration_stub(:SettingsChange) }

  migration_context :up do
    it "removes any job_proxy_dispatcher_interval settings changes" do
      settings_change1 = settings_change_stub.create!(:key => "/workers/worker_base/schedule_worker/job_proxy_dispatcher_interval", :value => "30.seconds")
      settings_change2 = settings_change_stub.create!(:key => "/workers/worker_base/schedule_worker/job_proxy_dispatcher_stale_message_timeout", :value => "30.seconds")
      settings_change3 = settings_change_stub.create!(:key => "/workers/worker_base/schedule_worker/job_proxy_dispatcher_stale_message_check_interval", :value => "30.seconds")
      migrate
      expect(settings_change1.reload.key).to eq("/workers/worker_base/schedule_worker/vm_scan_dispatcher_interval")
      expect(settings_change2.reload.key).to eq("/workers/worker_base/schedule_worker/vm_scan_dispatcher_stale_message_timeout")
      expect(settings_change3.reload.key).to eq("/workers/worker_base/schedule_worker/vm_scan_dispatcher_stale_message_check_interval")
    end

    it "doesn't remove unrelated settings changes" do
      settings_change = settings_change_stub.create!(:key => "/workers/worker_base/schedule_worker/evm_snapshot_interval", :value => "2.hours")
      migrate
      expect { settings_change_stub.find(settings_change.id) }.not_to raise_error
    end
  end

  migration_context :down do
    it "removes any job_proxy_dispatcher_interval settings changes" do
      settings_change1 = settings_change_stub.create!(:key => "/workers/worker_base/schedule_worker/vm_scan_dispatcher_interval", :value => "30.seconds")
      settings_change2 = settings_change_stub.create!(:key => "/workers/worker_base/schedule_worker/vm_scan_dispatcher_stale_message_timeout", :value => "30.seconds")
      settings_change3 = settings_change_stub.create!(:key => "/workers/worker_base/schedule_worker/vm_scan_dispatcher_stale_message_check_interval", :value => "30.seconds")
      migrate
      expect(settings_change1.reload.key).to eq("/workers/worker_base/schedule_worker/job_proxy_dispatcher_interval")
      expect(settings_change2.reload.key).to eq("/workers/worker_base/schedule_worker/job_proxy_dispatcher_stale_message_timeout")
      expect(settings_change3.reload.key).to eq("/workers/worker_base/schedule_worker/job_proxy_dispatcher_stale_message_check_interval")
    end

    it "doesn't remove unrelated settings changes" do
      settings_change = settings_change_stub.create!(:key => "/workers/worker_base/schedule_worker/evm_snapshot_interval", :value => "2.hours")
      migrate
      expect { settings_change_stub.find(settings_change.id) }.not_to raise_error
    end
  end
end
