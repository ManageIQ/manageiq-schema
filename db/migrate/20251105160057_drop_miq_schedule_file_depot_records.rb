class DropMiqScheduleFileDepotRecords < ActiveRecord::Migration[7.2]
  class MiqSchedule < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  def up
    say_with_time("Dropping schedules attached to file_depot records") do
      MiqSchedule.in_my_region.where.not(:file_depot_id => nil).delete_all
    end
  end
end
