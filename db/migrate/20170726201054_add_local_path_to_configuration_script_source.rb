class AddLocalPathToConfigurationScriptSource < ActiveRecord::Migration[5.0]
  def change
    add_column :configuration_script_sources, :local_path, :string
  end
end
