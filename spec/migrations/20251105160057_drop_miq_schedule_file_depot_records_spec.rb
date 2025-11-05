require_migration

class DropMiqScheduleFileDepotRecords < ActiveRecord::Migration[7.2]
  class FileDepot < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end
end

describe DropMiqScheduleFileDepotRecords do
  let(:file_depot_stub) { migration_stub(:FileDepot) }
  let(:miq_schedule_stub) { migration_stub(:MiqSchedule) }

  migration_context :up do
    it "deletes schedules associated to file depots" do
      file_depot = file_depot_stub.create!(:name => "my_file_depot")
      to_delete = miq_schedule_stub.create!(:name => "my_file_depot schedule", :file_depot_id => file_depot.id)
      to_keep = miq_schedule_stub.create!(:name => "other schedule", :file_depot_id => nil)

      migrate

      expect(miq_schedule_stub.count).to eq(1)
      expect(miq_schedule_stub.first).to eq(to_keep)
      expect { to_delete.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
