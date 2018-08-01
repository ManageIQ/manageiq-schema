class RenameUserMaintenanceZoneRecord < ActiveRecord::Migration[5.0]
  class Zone < ActiveRecord::Base
    include ActiveRecord::IdRegions

    validates_presence_of   :name

    MAINTENANCE_ZONE_NAME = "__maintenance__".freeze
  end

  def up
    say_with_time("Renaming user-defined Maintenance Zone") do
      zone = Zone.in_my_region.where(:name => Zone::MAINTENANCE_ZONE_NAME).first
      if zone.present?
        zone.name = "#{zone.name}_0"
        zone.save
      end
    end
  end

  def down
    say_with_time("Renaming user-defined Maintenance Zone") do
      Zone.in_my_region.where(:name => Zone::MAINTENANCE_ZONE_NAME).where(:visible => false).destroy_all

      orig = Zone.in_my_region.where(:name => "#{Zone::MAINTENANCE_ZONE_NAME}_0").first
      if orig.present?
        orig.name = orig.name[0..orig.name.size - 3]
        orig.save
      end
    end
  end
end
