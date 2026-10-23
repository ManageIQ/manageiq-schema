class RenameFirmwareFeaturesAndGrantToRoles < ActiveRecord::Migration[8.0]
  class MiqProductFeature < ActiveRecord::Base; end
  class MiqRolesFeature < ActiveRecord::Base; end

  FEATURE_MAPPING = {
    'firmware'           => 'firmware_registry',
    'firmware_view'      => 'firmware_registry_view',
    'firmware_show_list' => 'firmware_registry_show_list',
    'firmware_show'      => 'firmware_registry_show',
  }.freeze

  NEW_FEATURE_SETS = {
    'firmware_registry'           => %w[firmware_binary firmware_target],
    'firmware_registry_view'      => %w[firmware_binary_view firmware_target_view],
    'firmware_registry_show_list' => %w[firmware_binary_show_list firmware_target_show_list],
    'firmware_registry_show'      => %w[firmware_binary_show firmware_target_show],
  }.freeze

  def up
    return if MiqProductFeature.none?

    say_with_time('Renaming generic firmware features to firmware_registry') do
      FEATURE_MAPPING.each do |from, to|
        MiqProductFeature.find_by(:identifier => from)&.update!(:identifier => to)
      end
    end

    say_with_time('Granting firmware_binary and firmware_target features to roles with firmware_registry features') do
      NEW_FEATURE_SETS.each do |source_ident, target_idents|
        source_feature = MiqProductFeature.find_by(:identifier => source_ident)
        next unless source_feature

        target_features = target_idents.map { |ident| MiqProductFeature.find_or_create_by!(:identifier => ident) }

        MiqRolesFeature.where(:miq_product_feature_id => source_feature.id).each do |role_feature|
          target_features.each do |target_feature|
            MiqRolesFeature.find_or_create_by!(
              :miq_user_role_id       => role_feature.miq_user_role_id,
              :miq_product_feature_id => target_feature.id
            )
          end
        end
      end
    end
  end

  def down
    return if MiqProductFeature.none?

    say_with_time('Removing firmware_binary and firmware_target role mappings and features') do
      new_identifiers = NEW_FEATURE_SETS.values.flatten.uniq
      new_features = MiqProductFeature.where(:identifier => new_identifiers)
      MiqRolesFeature.where(:miq_product_feature_id => new_features.select(:id)).delete_all
      new_features.delete_all
    end

    say_with_time('Reverting firmware_registry features back to generic firmware') do
      FEATURE_MAPPING.each do |from, to|
        MiqProductFeature.find_by(:identifier => to)&.update!(:identifier => from)
      end
    end
  end
end
