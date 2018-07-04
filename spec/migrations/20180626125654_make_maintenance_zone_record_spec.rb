require_migration

describe MakeMaintenanceZoneRecord do
  let(:zone_stub) { migration_stub(:Zone) }

  migration_context :up do
    it "adds MaintenanceZone" do
      migrate

      expect(zone_stub.where(:name => 'maintenance').where(:visible => false).count).to eq(1)
    end
  end

  migration_context :down do
    it "removes MaintenanceZone" do
      zone_stub.create!(:name        => 'maintenance',
                        :description => 'Maintenance Zone',
                        :visible     => false)

      migrate

      expect(zone_stub.where(:name => 'maintenance').where(:visible => false).count).to eq(0)
    end
  end
end
