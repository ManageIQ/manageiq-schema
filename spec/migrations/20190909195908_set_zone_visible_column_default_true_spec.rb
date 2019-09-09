require_migration

describe SetZoneVisibleColumnDefaultTrue do
  let(:zone_stub) { migration_stub(:Zone) }

  migration_context :up do
    it "changes visible => nil to true" do
      zone = zone_stub.create(:visible => nil)
      migrate
      zone.reload
      expect(zone.visible).to be true
    end
  end

  migration_context :down do
    it "leaves visible => true as true because we can't assume it was previously nil" do
      zone = zone_stub.create(:visible => true)
      migrate
      zone.reload
      expect(zone.visible).to be true
    end

    it "changes visible => nil to true, it doesn't reverse the update_all when running it" do
      zone = zone_stub.create(:visible => nil)
      migrate
      zone.reload
      expect(zone.visible).to be true
    end
  end
end
