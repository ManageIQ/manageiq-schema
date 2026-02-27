class AddConfigurationScriptForEmbeddedPayloads < ActiveRecord::Migration[8.0]
  PAYLOAD_TO_SCRIPT_MAPPING = {
    "ManageIQ::Providers::EmbeddedAnsible::AutomationManager::Playbook"   => "ManageIQ::Providers::EmbeddedAnsible::AutomationManager::ConfigurationScript",
    "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Template" => "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::ConfigurationScript"
  }.freeze

  class ConfigurationScriptBase < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.table_name = "configuration_scripts"
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Creating ConfigurationScripts for EmbeddedAutomation Payloads") do
      ConfigurationScriptBase.in_my_region.where(:type => PAYLOAD_TO_SCRIPT_MAPPING.keys).each do |payload|
        attrs = payload.attributes.slice("manager_id", "name")
        attrs["type"]      = PAYLOAD_TO_SCRIPT_MAPPING[payload.type]
        attrs["parent_id"] = payload.id

        ConfigurationScriptBase.create!(attrs)
      end
    end
  end

  def down
    say_with_time("Deleting EmbeddedAutomation ConfigurationScripts") do
      ConfigurationScriptBase.in_my_region.where(:type => PAYLOAD_TO_SCRIPT_MAPPING.values).delete_all
    end
  end
end
