class MigrateConditionsTowHatToResourceType < ActiveRecord::Migration[5.0]
  class Condition < ActiveRecord::Base
  end

  def up
    say_with_time("Moving Condition towhat to resource type") do
      Condition.find_each do |condition|
        condition.update(:resource_type => condition.towhat)
      end
    end
  end

  def down
    say_with_time("Moving Condition resource type to towhat") do
      Condition.find_each do |condition|
        condition.update(:towhat => condition.resource_type)
      end
    end
  end
end
