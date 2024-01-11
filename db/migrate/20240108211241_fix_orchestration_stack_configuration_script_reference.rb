class FixOrchestrationStackConfigurationScriptReference < ActiveRecord::Migration[6.1]
  class OrchestrationStack < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  TYPES = %w[ManageIQ::Providers::Awx::AutomationManager::Job ManageIQ::Providers::AnsibleTower::AutomationManager::Job].freeze

  def up
    say_with_time("Fixing OrchestrationStack#configuration_script foreign key") do
      OrchestrationStack.in_my_region.where(:type => TYPES).update_all('configuration_script_id = orchestration_template_id')
      OrchestrationStack.in_my_region.where(:type => TYPES).update_all(:orchestration_template_id => nil)
    end
  end

  def down
    say_with_time("Resetting OrchestrationStack#configuration_script foreign key") do
      OrchestrationStack.in_my_region.where(:type => TYPES).update_all('orchestration_template_id = configuration_script_id')
      OrchestrationStack.in_my_region.where(:type => TYPES).update_all(:configuration_script_id => nil)
    end
  end
end
