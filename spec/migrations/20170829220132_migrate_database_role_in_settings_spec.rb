require_migration

describe MigrateDatabaseRoleInSettings do
  let(:settings_change_stub) { migration_stub(:SettingsChange) }

  migration_context :up do
    it "converts the old data" do
      setting_changed = settings_change_stub.create!(:key => "/server/role", :value => "database,event,reporting")
      setting_ignored = settings_change_stub.create!(:key => "/other/settings", :value => "database")

      migrate

      expect(setting_changed.reload.value).to eq("database_operations,event,reporting")
      expect(setting_ignored.reload.value).to eq("database")
    end

    it "ignores already converted data" do
      setting_changed = settings_change_stub.create!(:key => "/server/role", :value => "database_operations,event,reporting")

      migrate

      expect(setting_changed.reload.value).to eq("database_operations,event,reporting")
    end
  end
end
