class SetManagerRefEmbeddedConfigurationScripts < ActiveRecord::Migration[6.1]
  class ConfigurationScript < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  EMBEDDED_CONFIGURATION_SCRIPT_TYPES = %w[
    ManageIQ::Providers::EmbeddedAnsible::AutomationManager::Playbook
    ManageIQ::Providers::Workflows::AutomationManager::Workflow
  ].freeze

  def up
    ConfigurationScript.in_my_region.where(:type => EMBEDDED_CONFIGURATION_SCRIPT_TYPES).update_all("manager_ref = name")
  end

  def down
    ConfigurationScript.in_my_region.where(:type => EMBEDDED_CONFIGURATION_SCRIPT_TYPES).update_all(:manager_ref => nil)
  end
end
