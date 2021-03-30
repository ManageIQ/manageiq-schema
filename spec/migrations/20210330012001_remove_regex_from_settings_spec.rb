require_migration

describe RemoveRegexFromSettings do
  let(:settings_change_stub) { migration_stub(:SettingsChange) }

  migration_context :up do
    it "converts regular expression object to a string" do
      record = settings_change_stub.create!(
        :resource_type => "MiqServer",
        :key           => "/ems/ems_nuage/event_handling/event_groups/addition/critical",
        :value         => ["/hello/","beautiful",/world/]

      )
      migrate

      record.reload
      expect(record.value).to eq(["/hello/","beautiful","/world/"])
    end
  end
end
