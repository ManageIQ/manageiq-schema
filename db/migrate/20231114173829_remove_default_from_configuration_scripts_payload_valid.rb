class RemoveDefaultFromConfigurationScriptsPayloadValid < ActiveRecord::Migration[6.1]
  def up
    change_column_default :configuration_scripts, :payload_valid, nil
  end

  def down
    change_column_default :configuration_scripts, :payload_valid, true
  end
end
