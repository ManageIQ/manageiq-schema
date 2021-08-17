require_migration

describe RemoveMemcacheServerOpts do
  let(:settings_change_stub) { migration_stub(:SettingsChange) }

  migration_context :up do
    it "Deletes memcache_server_opts settings" do
      settings_change_stub.create!(:key => "/session/memcache_server_opts")
      migrate
      expect(settings_change_stub.count).to be_zero
    end

    it "Doesn't impact unrelated settings" do
      session_timeout = settings_change_stub.create!(:key => "/session/timeout", :value => "3600")
      migrate
      expect(session_timeout.reload.value).to eq("3600")
    end
  end
end
