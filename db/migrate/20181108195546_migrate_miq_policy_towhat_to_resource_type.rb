class MigrateMiqPolicyTowhatToResourceType < ActiveRecord::Migration[5.0]
  class MiqPolicy < ActiveRecord::Base
  end

  def up
    say_with_time("Moving MiqPolicy towhat to resource type") do
      MiqPolicy.find_each do |policy|
        policy.update(:resource_type => policy.towhat)
      end
    end
  end

  def down
    say_with_time("Moving MiqPolicy resource type to towhat") do
      MiqPolicy.find_each do |policy|
        policy.update(:towhat => policy.resource_type)
      end
    end
  end
end
