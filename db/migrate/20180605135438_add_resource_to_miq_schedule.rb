class AddResourceToMiqSchedule < ActiveRecord::Migration[5.0]
  class MiqSchedule < ActiveRecord::Base
    self.inheritance_column = :_type_disabled

    include ReservedMigrationMixin
  end

  def up
    add_column :miq_schedules, :resource_id, :bigint

    say_with_time("Migrate data from reserved table to MiqSchedule") do
      MiqSchedule.includes(:reserved_rec).each do |schedule|
        schedule.reserved_hash_migrate(:resource_id)
      end
    end
  end

  def down
    say_with_time("Migrate data from MiqSchedule to reserved table") do
      MiqSchedule.includes(:reserved_rec).each do |schedule|
        schedule.reserved_hash_set(:resource_id, schedule.resource_id)
        schedule.save!
      end
    end

    remove_column :miq_schedules, :resource_id
  end
end
