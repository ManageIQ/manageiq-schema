require_migration

describe AddResourceToMiqSchedule do
  let(:reserve_stub)      { Spec::Support::MigrationStubs.reserved_stub }
  let(:miq_schedule_stub) { migration_stub(:MiqSchedule) }
  let(:resource_id)       { anonymous_class_with_id_regions.id_in_region(1, anonymous_class_with_id_regions.my_region_number) }

  migration_context :up do
    it "Migrates Reserve data to MiqSchedule" do
      schedule = miq_schedule_stub.create!
      reserve_stub.create!(
        :resource_type => schedule.class.name,
        :resource_id   => schedule.id,
        :reserved      => {
          :resource_id => resource_id,
        }
      )

      migrate

      schedule.reload

      expect(reserve_stub.count).to eq(0)
      expect(schedule.resource_id).to eq(resource_id)
    end
  end

  migration_context :down do
    it "Migrates resource_id in MiqSchedule to Reserve table" do
      schedule = miq_schedule_stub.create!(:resource_id => resource_id)

      migrate

      expect(reserve_stub.count).to eq(1)

      reserved_rec = reserve_stub.first
      expect(reserved_rec.resource_id).to   eq(schedule.id)
      expect(reserved_rec.resource_type).to eq(schedule.class.name)

      expect(reserved_rec.reserved[:resource_id]).to eq(resource_id)
    end
  end
end
