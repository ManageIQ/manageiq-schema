class AddTargetPlatformToConfigurationProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :configuration_profiles, :target_platform, :string
  end
end
