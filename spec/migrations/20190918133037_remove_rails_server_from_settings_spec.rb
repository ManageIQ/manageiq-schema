require_migration

describe RemoveRailsServerFromSettings do
  let(:settings_change_stub) { migration_stub(:SettingsChange) }

  migration_context :up do
    let(:worker_stub) { migration_stub(:MiqWorker) }

    it "removes rows with /server/rails_server key" do
      setting_changed = settings_change_stub.create!(:key => "/server/rails_server", :value => "thin")
      setting_ignored = settings_change_stub.create!(:key => "/server/other_key", :value => "something")

      migrate

      expect { setting_changed.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(setting_ignored.reload.value).to eq("something")
    end
  end
end
