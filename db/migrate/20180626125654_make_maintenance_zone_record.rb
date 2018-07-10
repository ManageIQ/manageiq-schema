class MakeMaintenanceZoneRecord < ActiveRecord::Migration[5.0]
  class Zone < ActiveRecord::Base
    validates_presence_of   :name
    validates_uniqueness_of :name

    MAINTENANCE_ZONE_NAME = "__maintenance__".freeze
  end

  def up
    say_with_time("Creating Maintenance Zone") do
      zone = Zone.where(:name => Zone::MAINTENANCE_ZONE_NAME).first
      if zone.present?
        zone.name = "#{zone.name}_0"
        zone.save
      end

      Zone.create_with(:description => "Maintenance Zone", :visible => false).find_or_create_by!(:name => Zone::MAINTENANCE_ZONE_NAME)
    end
  end

  def down
    say_with_time("Deleting Maintenance Zone") do
      Zone.where(:name => Zone::MAINTENANCE_ZONE_NAME).where(:visible => false).destroy_all

      orig = Zone.where(:name => "#{Zone::MAINTENANCE_ZONE_NAME}_0").first
      if orig.present?
        orig.name = orig.name[0..orig.name.size - 3]
        orig.save
      end
    end
  end
end
