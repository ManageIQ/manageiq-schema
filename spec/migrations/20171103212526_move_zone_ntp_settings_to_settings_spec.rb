require_migration

describe MoveZoneNtpSettingsToSettings do
  let(:settings_change_stub) { migration_stub(:SettingsChange) }
  let(:zone_stub)            { migration_stub(:Zone) }
  let(:servers)              { ["1.example.com", "2.example.com"] }

  migration_context :up do
    it "moves NTP settings from Zone#settings to SettingsChange" do
      zone = zone_stub.create!(:settings => {:ntp => {:server => servers}})

      migrate

      expect(
        settings_change_stub.find_by(
          :key           => "/ntp/server",
          :resource_id   => zone.id,
          :resource_type => "Zone",
        ).value
      ).to eq(servers)
      expect(zone.reload.settings).to be_blank
    end

    it "Skips when there are no NTP settings" do
      zone_stub.create!

      migrate

      expect(settings_change_stub.count).to eq(0)
      expect(zone_stub.count).to eq(1)
    end
  end

  migration_context :down do
    it "moves NTP settings from Zone#settings to SettingsChange" do
      zone = zone_stub.create!
      settings_change_stub.create!(:resource_type => "Zone", :resource_id => zone.id, :key => "/ntp/server", :value => servers)

      migrate

      expect(settings_change_stub.count).to eq(0)
      expect(zone.reload.settings).to eq(:ntp => {:server => servers})
    end

    it "Skips when there are no NTP settings" do
      zone = zone_stub.create!

      migrate

      expect(zone.reload.settings).to eq({})
    end
  end
end
