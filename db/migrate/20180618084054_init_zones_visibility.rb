class InitZonesVisibility < ActiveRecord::Migration[5.0]
  class Zone < ActiveRecord::Base
  end

  def up
    say_with_time("Updating all zones to visible") do
      Zone.update_all(:visible => true)
    end
  end

  def down
    say_with_time("Resetting zone visibility") do
      Zone.update_all(:visible => nil)
    end
  end
end
