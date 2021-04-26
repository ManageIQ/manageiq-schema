class FixOpenstackOrchestrationStackStiClass < ActiveRecord::Migration[6.0]
  class OrchestrationStack < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Fix Openstack OrchestrationStack STI class") do
      OrchestrationStack.in_my_region
                        .where(:type => "ManageIQ::Providers::CloudManager::OrchestrationStack")
                        .update_all(:type => "ManageIQ::Providers::Openstack::CloudManager::OrchestrationStack")
    end
  end

  def down
    say_with_time("Fix Openstack OrchestrationStack STI class") do
      OrchestrationStack.in_my_region
                        .where(:type => "ManageIQ::Providers::Openstack::CloudManager::OrchestrationStack")
                        .update_all(:type => "ManageIQ::Providers::CloudManager::OrchestrationStack")
    end
  end
end
