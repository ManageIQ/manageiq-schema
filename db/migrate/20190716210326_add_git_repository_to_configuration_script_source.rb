class AddGitRepositoryToConfigurationScriptSource < ActiveRecord::Migration[5.1]
  def change
    add_column :configuration_script_sources, :git_repository_id, :bigint
  end
end
