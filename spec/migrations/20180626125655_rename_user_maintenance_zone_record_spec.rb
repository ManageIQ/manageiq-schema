require_migration

describe RenameUserMaintenanceZoneRecord do
  let(:zone_stub) { migration_stub(:Zone) }
  let(:job_stub) { migration_stub(:Job) }
  let(:miq_task_stub) { migration_stub(:MiqTask) }
  let(:miq_queue_stub) { migration_stub(:MiqQueue) }

  let(:remote_region_start) do
    anonymous_class_with_id_regions.rails_sequence_start +
      anonymous_class_with_id_regions.rails_sequence_factor
  end

  migration_context :up do
    it "renames original maintenance zone" do
      orig = zone_stub.create!(:name => zone_stub::MAINTENANCE_ZONE_NAME)

      migrate
      orig.reload

      expect(orig.name).to eq("#{zone_stub::MAINTENANCE_ZONE_NAME}_#{zone_stub.my_region_number}")
    end

    it "does not rename zone from remote regions" do
      id = remote_region_start

      user_zone = zone_stub.create!(:id   => id,
                                    :name => zone_stub::MAINTENANCE_ZONE_NAME)

      migrate
      user_zone.reload

      expect(user_zone.name).to eq(zone_stub::MAINTENANCE_ZONE_NAME)
    end

    it "renames string associations belonging to former maintenance zone" do
      orig = zone_stub.create!(:name => zone_stub::MAINTENANCE_ZONE_NAME)
      assoc = {}
      assoc[:miq_task]  = miq_task_stub.create!(:zone => orig.name)
      assoc[:job]       = job_stub.create!(:zone => orig.name, :miq_task => assoc[:miq_task])
      assoc[:miq_queue] = miq_queue_stub.create!(:zone => orig.name, :miq_task => assoc[:miq_task])

      migrate
      orig.reload
      assoc.each_value do |record|
        record.reload
        expect(record.zone).to eq(orig.name)
      end
    end

    it "does not rename unrelated jobs, tasks and queues" do
      orig = zone_stub.create!(:name => zone_stub::MAINTENANCE_ZONE_NAME)
      other_zone_name = "Some other zone"
      other = zone_stub.create!(:name => other_zone_name)

      assoc = {}
      assoc[:miq_task]  = miq_task_stub.create!(:zone => other.name)
      assoc[:job]       = job_stub.create!(:zone => other.name, :miq_task => assoc[:miq_task])
      assoc[:miq_queue] = miq_queue_stub.create!(:zone => other.name, :miq_task => assoc[:miq_task])

      migrate
      orig.reload
      other.reload
      expect(other.name).to eq(other_zone_name)
      assoc.each_value do |record|
        record.reload
        expect(record.zone).to eq(other_zone_name)
      end
    end

    it "raises error when original zone renamed to existing one" do
      zone_stub.create!(:name => zone_stub::MAINTENANCE_ZONE_NAME)
      zone_stub.create!(:name => "#{zone_stub::MAINTENANCE_ZONE_NAME}_#{zone_stub.my_region_number}")
      expect { migrate }.to raise_error(/is not unique within region/)
    end
  end

  migration_context :down do
    it "removes MaintenanceZone" do
      zone_stub.create!(:name        => zone_stub::MAINTENANCE_ZONE_NAME,
                        :description => 'Maintenance Zone',
                        :visible     => false)

      migrate

      expect(zone_stub.where(:name => zone_stub::MAINTENANCE_ZONE_NAME).where(:visible => false).count).to eq(0)
    end

    it "renames original maintenance zone back" do
      orig = zone_stub.create!(:name => "#{zone_stub::MAINTENANCE_ZONE_NAME}_#{zone_stub.my_region_number}")

      migrate
      orig.reload

      expect(orig.name).to eq(zone_stub::MAINTENANCE_ZONE_NAME)
    end

    it "does not rename original maintenance zone from remote region" do
      id = remote_region_start

      user_zone = zone_stub.create!(:id   => id,
                                    :name => "#{zone_stub::MAINTENANCE_ZONE_NAME}_#{zone_stub.my_region_number}")

      migrate
      user_zone.reload

      expect(user_zone.name).to eq("#{zone_stub::MAINTENANCE_ZONE_NAME}_#{zone_stub.my_region_number}")
    end

    it "renames string associations belonging to original maintenance zone back" do
      orig = zone_stub.create!(:name => "#{zone_stub::MAINTENANCE_ZONE_NAME}_#{zone_stub.my_region_number}")
      assoc = {}
      assoc[:miq_task]  = miq_task_stub.create!(:zone => orig.name)
      assoc[:job]       = job_stub.create!(:zone => orig.name, :miq_task => assoc[:miq_task])
      assoc[:miq_queue] = miq_queue_stub.create!(:zone => orig.name, :miq_task => assoc[:miq_task])

      migrate
      orig.reload
      assoc.each_value do |record|
        record.reload
        expect(record.zone).to eq(orig.name)
      end
    end
  end
end
