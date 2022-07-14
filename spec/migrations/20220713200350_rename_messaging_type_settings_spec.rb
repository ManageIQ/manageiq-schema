require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe RenameMessagingTypeSettings do
  let(:settings_change_stub) { migration_stub(:SettingsChange) }

  migration_context :up do
    it "renames messaging_type out of prototype and defaults to kafka" do
      settings_change = settings_change_stub.create!(:key => "/prototype/messaging_type")
      migrate
      settings_change.reload
      expect(settings_change.key).to eq("/messaging_type")
      expect(settings_change.value).to eq("kafka")
    end
  end

  migration_context :down do
    it "renames messaging_type out of prototype and defaults to kafka" do
      settings_change = settings_change_stub.create!(:key => "/prototype/messaging_type")
      migrate
      settings_change.reload
      expect(settings_change.key).to eq("/messaging_type")
      expect(settings_change.value).to eq("kafka")
    end
  end
end
