class AddLastUpdatedOnToConfigurationScriptSource < ActiveRecord::Migration[5.0]
  def change
    add_column :configuration_script_sources, :last_updated_on, :timestamp
  end
end
