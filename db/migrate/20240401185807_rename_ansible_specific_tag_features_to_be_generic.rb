class RenameAnsibleSpecificTagFeaturesToBeGeneric < ActiveRecord::Migration[6.1]
  class MiqProductFeature < ActiveRecord::Base; end
  class MiqRolesFeature < ActiveRecord::Base; end

  FEATURE_MAPPING = {
    'ansible_repository_tag' => 'embedded_configuration_script_source_tag',
    'ansible_credential_tag' => 'embedded_automation_manager_credential_tag',
  }.freeze

  def up
    return if MiqProductFeature.none?

    say_with_time 'Renaming ansible specific product features to be generic embedded' do
      # Direct renaming of features
      FEATURE_MAPPING.each do |from, to|
        MiqProductFeature.find_by(:identifier => from)&.update!(:identifier => to)
      end
    end
  end

  def down
    return if MiqProductFeature.none?

    say_with_time 'Renaming generic embedded product features back to specific ansible ones' do
      FEATURE_MAPPING.each do |to, from|
        MiqProductFeature.find_by(:identifier => from)&.update!(:identifier => to)
      end
    end
  end
end
