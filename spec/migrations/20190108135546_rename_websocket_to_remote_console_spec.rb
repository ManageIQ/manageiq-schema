require_migration

describe RenameWebsocketToRemoteConsole do
  let(:settings_change_stub) { migration_stub(:SettingsChange) }

  migration_context :up do
    it "converts the server roles" do
      setting_changed = settings_change_stub.create!(:key => "/server/role", :value => "database,websocket,reporting")
      setting_ignored = settings_change_stub.create!(:key => "/server/role", :value => "database,reporting")

      migrate

      expect(setting_changed.reload.value).to eq("database,remote_console,reporting")
      expect(setting_ignored.reload.value).to eq("database,reporting")
    end

    it "converts the log levels" do
      setting_changed = settings_change_stub.create!(:key => "/log/level_websocket", :value => "foo")
      setting_ignored = settings_change_stub.create!(:key => "/log/level_api", :value => "bar")

      migrate

      expect(setting_changed.reload.key).to eq("/log/level_remote_console")
      expect(setting_changed.value).to eq("foo")
      expect(setting_ignored.reload.key).to eq("/log/level_api")
      expect(setting_ignored.value).to eq("bar")
    end

    it "converts the worker settings" do
      setting_changed = settings_change_stub.create!(:key => "/workers/worker_base/websocket_worker/anything", :value => "foo")
      setting_ignored = settings_change_stub.create!(:key => "/workers/worker_base/sleepy_worker", :value => "bar")

      migrate

      expect(setting_changed.reload.key).to eq("/workers/worker_base/remote_console_worker/anything")
      expect(setting_changed.value).to eq("foo")
      expect(setting_ignored.reload.key).to eq("/workers/worker_base/sleepy_worker")
      expect(setting_ignored.value).to eq("bar")
    end
  end

  migration_context :down do
    it "converts the server roles" do
      setting_changed = settings_change_stub.create!(:key => "/server/role", :value => "database,remote_console,reporting")
      setting_ignored = settings_change_stub.create!(:key => "/server/role", :value => "database,reporting")

      migrate

      expect(setting_changed.reload.value).to eq("database,websocket,reporting")
      expect(setting_ignored.reload.value).to eq("database,reporting")
    end

    it "converts the log levels" do
      setting_changed = settings_change_stub.create!(:key => "/log/level_remote_console", :value => "foo")
      setting_ignored = settings_change_stub.create!(:key => "/log/level_api", :value => "bar")

      migrate

      expect(setting_changed.reload.key).to eq("/log/level_websocket")
      expect(setting_changed.value).to eq("foo")
      expect(setting_ignored.reload.key).to eq("/log/level_api")
      expect(setting_ignored.value).to eq("bar")
    end

    it "converts the worker settings" do
      setting_changed = settings_change_stub.create!(:key => "/workers/worker_base/remote_console_worker/anything", :value => "foo")
      setting_ignored = settings_change_stub.create!(:key => "/workers/worker_base/sleepy_worker", :value => "bar")

      migrate

      expect(setting_changed.reload.key).to eq("/workers/worker_base/websocket_worker/anything")
      expect(setting_changed.value).to eq("foo")
      expect(setting_ignored.reload.key).to eq("/workers/worker_base/sleepy_worker")
      expect(setting_ignored.value).to eq("bar")
    end
  end
end
