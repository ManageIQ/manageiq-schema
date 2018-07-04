require_migration
describe InitZonesVisibility do
  let(:zone_stub) { migration_stub(:Zone) }

  migration_context :up do
    it "makes zones visible" do
      zone = zone_stub.create!(:name => 'zone1')

      migrate
      zone.reload

      expect(zone.visible).to be_truthy
    end
  end

  migration_context :down do
    it 'resets zone visibility' do
      zone = zone_stub.create!(:name => 'zone_visible', :visible => true)

      migrate
      zone.reload

      expect(zone.visible).to be_nil
    end
  end
end
