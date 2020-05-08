class RenameForemanFeatures < ActiveRecord::Migration[5.1]
  class MiqProductFeature < ActiveRecord::Base; end
  class MiqRolesFeature < ActiveRecord::Base; end
  class User < ActiveRecord::Base
    serialize :settings, Hash
  end

  FEATURE_MAPPING = {
    'providers_accord'                   => 'ems_configuration',
    'provider_foreman_view'              => 'ems_configuration_view',
    'provider_foreman_control'           => 'ems_configuration_control',
    'configuration_manager_provider_tag' => 'ems_configuration_tag',
    'provider_admin'                     => 'ems_configuration_admin',
    'provider_foreman_delete_provider'   => 'ems_configuration_delete_provider',
    'provider_foreman_edit_provider'     => 'ems_configuration_edit_provider',
    'provider_foreman_add_provider'      => 'ems_configuration_add_provider',
    'configured_systems_filter_accord'   => 'configured_system',
  }.freeze

  ROLES_FEATURE_MAPPING = {
    'provider_foreman_explorer'             => %w[ems_configuration configured_system configuration_profile],
    'configured_systems_filter_accord'      => %w[configured_system],
    'configured_systems_filter_accord_view' => %w[configured_system_view],
    'configuredsystem_control'              => %w[configured_system_control],
  }.freeze

  def up
    return if MiqProductFeature.none?

    say_with_time 'Renaming old foreman explorer features to the non-explorer ones' do
      # Direct renaming of features
      FEATURE_MAPPING.each do |from, to|
        MiqProductFeature.find_by(:identifier => from)&.update!(:identifier => to)
      end

      # Mapping to already existing features
      ROLES_FEATURE_MAPPING.each do |from, to|
        from_feature = MiqProductFeature.find_or_create_by!(:identifier => from)
        to_features = to.map { |identifier| MiqProductFeature.find_or_create_by!(:identifier => identifier) }

        MiqRolesFeature.where(:miq_product_feature_id => from_feature.id).each do |roles_feature|
          to_features.each do |to_feature|
            MiqRolesFeature.create!(:miq_product_feature_id => to_feature.id, :miq_user_role_id => roles_feature.miq_user_role_id)
          end
        end
      end
    end

    say_with_time 'Updating starting page for users who had foreman explorer set' do
      # Update starting page for users who had it on provider_foreman/explorer
      User.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'provider_foreman/explorer'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'ems_configuration/show_list'}))
        end
      end
    end
  end

  def down
    return if MiqProductFeature.none?

    say_with_time 'Renaming new ems configuration features to old foreman explorer ones' do
      FEATURE_MAPPING.each do |to, from|
        MiqProductFeature.find_by(:identifier => from)&.update!(:identifier => to)
      end

      ROLES_FEATURE_MAPPING.each do |to, from|
        next if from.length > 1 # The explorer one is redundant if all its 3 children are checked

        from_feature = MiqProductFeature.find_or_create_by!(:identifier => from.first)
        to_feature = MiqProductFeature.find_or_create_by!(:identifier => to.first)

        MiqRolesFeature.where(:miq_product_feature_id => from_feature.id)&.update(:miq_product_feature_id => to_feature.id)
      end
    end

    say_with_time 'Updating starting page for users who had non-explorer ems_configuration pages set' do
      User.select(:id, :settings).each do |user|
        if %w[ems_configuration/show_list configuration_profile/show_list configured_system/show_list].include?(user.settings&.dig(:display, :startpage))
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'provider_foreman/explorer'}))
        end
      end
    end
  end
end
