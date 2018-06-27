class MakeMaintenanceZoneRecord < ActiveRecord::Migration[5.0]
  class Zone < ActiveRecord::Base
  end

  def up
    say_with_time("Creating Maintenance Zone") do
      Zone.create_with(:description => "Maintenance Zone", :visible => false).find_or_create_by!(:name => 'maintenance')
    end
  end

  def down
    say_with_time("Deleting Maintenance Zone") do
      Zone.where(:name => 'maintenance').where(:visible => false).destroy_all
    end
  end
end
