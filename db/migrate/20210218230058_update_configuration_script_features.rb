class UpdateConfigurationScriptFeatures < ActiveRecord::Migration[5.1]
  class MiqProductFeature < ActiveRecord::Base; end
  class MiqRolesFeature < ActiveRecord::Base; end

  FEATURE_MAPPING = {
    'automation_manager_configuration_scripts_accord'        => 'configuration_script',
    'automation_manager_configuration_script_view'           => 'configuration_script_view',
    'automation_manager_configuration_script_control'        => 'configuration_script_control',
    'automation_manager_configuration_script_service_dialog' => 'configuration_script_service_dialog',
    'automation_manager_configuration_script_tag'            => 'configuration_script_tag'
  }.freeze

  def up
    return if MiqProductFeature.none?

    say_with_time 'Adjusting Configuration Script features for the non-explorer views' do
      # Direct renaming of features
      FEATURE_MAPPING.each do |from, to|
        MiqProductFeature.find_by(:identifier => from)&.update!(:identifier => to)
      end
    end
  end

  def down
    return if MiqProductFeature.none?

    say_with_time 'Adjust Configuration Script features to explorer views' do
      FEATURE_MAPPING.each do |to, from|
        MiqProductFeature.find_by(:identifier => from)&.update!(:identifier => to)
      end
    end
  end
end
