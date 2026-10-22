class SetOrchestrationStackOutputValueTypeToString < ActiveRecord::Migration[8.0]
  class OrchestrationStackOutput < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  def up
    say_with_time("Setting OrchestrationStackOutput value_type to string") do
      OrchestrationStackOutput.in_my_region.where(:value_type => nil).update_all(:value_type => "string")
    end
  end

  def down
    say_with_time("Clearing OrchestrationStackOutput value_type") do
      OrchestrationStackOutput.in_my_region.update_all(:value_type => nil)
    end
  end
end
