class FixConversionHostResourceType < ActiveRecord::Migration[5.0]
  class ConversionHost < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    include ActiveRecord::IdRegions
  end

  def up
    say_with_time("Converting invalid resource_type to Host") do
      ConversionHost.in_my_region
                    .where(:resource_type => "AddConversionHostIdToMiqRequestTasks::Host")
                    .update_all(:resource_type => "Host")
    end
  end
end
