class RemoveLocalDefaultEmbeddedAnsibleRepos < ActiveRecord::Migration[5.1]
  class ConfigurationScriptSource < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled # disable STI
  end

  class GitRepository < ActiveRecord::Base; end

  CONFIGURATION_SCRIPT_TYPE = "ManageIQ::Providers::EmbeddedAnsible::AutomationManager::ConfigurationScriptSource".freeze

  def up
    css = ConfigurationScriptSource.in_my_region.where(:type => CONFIGURATION_SCRIPT_TYPE).where("scm_url LIKE ? OR scm_url = ?", "%/content/ansible_consolidated", "file:///var/lib/awx_consolidated_source")

    GitRepository.where(:id => css.pluck(:git_repository_id).compact).delete_all
    css.delete_all
  end
end
