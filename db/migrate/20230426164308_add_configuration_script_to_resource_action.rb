class AddConfigurationScriptToResourceAction < ActiveRecord::Migration[6.1]
  def change
    add_reference :resource_actions, :configuration_script
  end
end
