class RemoveConfigurationTemplatesTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :configuration_templates
  end
end
