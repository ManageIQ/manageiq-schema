require_migration

describe MakeMaintenanceZoneRecord do
  let(:zone_stub) { migration_stub(:Zone) }

  let(:remote_region_start) do
    anonymous_class_with_id_regions.rails_sequence_start +
      anonymous_class_with_id_regions.rails_sequence_factor
  end

  migration_context :up do
    before(:each) do
      zone_stub.delete_all
    end

    it "adds MaintenanceZone" do
      migrate

      expect(zone_stub.where(:name => zone_stub::MAINTENANCE_ZONE_NAME).where(:visible => false).count).to eq(1)
    end

    it "renames original maintenance zone" do
      orig = zone_stub.create!(:name => zone_stub::MAINTENANCE_ZONE_NAME)

      migrate
      orig.reload

      expect(orig.name).to eq("#{zone_stub::MAINTENANCE_ZONE_NAME}_0")
    end

    it "does not rename zone from remote regions" do
      id = remote_region_start

      user_zone = zone_stub.create!(:id   => id,
                                    :name => zone_stub::MAINTENANCE_ZONE_NAME)

      migrate
      user_zone.reload

      expect(user_zone.name).to eq(zone_stub::MAINTENANCE_ZONE_NAME)
    end
  end

  migration_context :down do
    before(:each) do
      zone_stub.delete_all
    end

    it "removes MaintenanceZone" do
      zone_stub.create!(:name        => zone_stub::MAINTENANCE_ZONE_NAME,
                        :description => 'Maintenance Zone',
                        :visible     => false)

      migrate

      expect(zone_stub.where(:name => zone_stub::MAINTENANCE_ZONE_NAME).where(:visible => false).count).to eq(0)
    end

    it "renames original maintenance zone back" do
      orig = zone_stub.create!(:name => "#{zone_stub::MAINTENANCE_ZONE_NAME}_0")

      migrate
      orig.reload

      expect(orig.name).to eq(zone_stub::MAINTENANCE_ZONE_NAME)
    end

    it "does not rename original maintenance zone from remote region" do
      id = remote_region_start

      user_zone = zone_stub.create!(:id   => id,
                                    :name => "#{zone_stub::MAINTENANCE_ZONE_NAME}_0")

      migrate
      user_zone.reload

      expect(user_zone.name).to eq("#{zone_stub::MAINTENANCE_ZONE_NAME}_0")
    end
  end
end
