class UpdateAutomationProviderFeatures < ActiveRecord::Migration[6.0]
  class MiqProductFeature < ActiveRecord::Base; end
  class MiqRolesFeature < ActiveRecord::Base; end

  FEATURE_MAPPING = {
    'automation_manager'                   => 'ems_automation',
    'automation_manager_admin'             => 'ems_automation_admin',
    'automation_manager_resume'            => 'ems_automation_resume',
    'automation_manager_providers_view'    => 'ems_automation_view',
    'automation_manager_delete_provider'   => 'ems_automation_delete_provider',
    'automation_manager_edit_provider'     => 'ems_automation_edit_provider',
    'automation_manager_pause'             => 'ems_automation_pause',
    'automation_manager_providers_control' => 'ems_automation_control',
    'automation_manager_refresh_provider'  => 'ems_automation_refresh_provider',
    'automation_manager_provider_tag'      => 'ems_automation_tag'
  }.freeze

  def up
    return if MiqProductFeature.none?

    say_with_time 'Adjusting Automation Provider features for the non-explorer views' do
      # Direct renaming of features
      FEATURE_MAPPING.each do |from, to|
        MiqProductFeature.find_by(:identifier => from)&.update!(:identifier => to)
      end
    end
  end

  def down
    return if MiqProductFeature.none?

    say_with_time 'Adjust Automation Provider features to explorer views' do
      FEATURE_MAPPING.each do |to, from|
        MiqProductFeature.find_by(:identifier => from)&.update!(:identifier => to)
      end
    end
  end
end
