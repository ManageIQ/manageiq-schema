class EnsureEmsStorageFeatures < ActiveRecord::Migration[6.0]
  class MiqUserRole < ActiveRecord::Base
    has_and_belongs_to_many :miq_product_features, :join_table => :miq_roles_features, :class_name => "EnsureEmsStorageFeatures::MiqProductFeature"
  end

  class MiqProductFeature < ActiveRecord::Base
    has_and_belongs_to_many :miq_user_roles, :join_table => :miq_roles_features, :class_name => "EnsureEmsStorageFeatures::MiqUserRole"
  end

  BLOCK_STORAGE_FEATURES = %w[ems_block_storage ems_block_storage_view ems_block_storage_show_list
                              ems_block_storage_show ems_block_storage_timeline ems_block_storage_control
                              ems_block_storage_tag ems_block_storage_protect ems_block_storage_refresh
                              ems_block_storage_admin ems_block_storage_new ems_block_storage_edit
                              ems_block_storage_delete].freeze
  OBJECT_STORAGE_FEATURES = %w[ems_object_storage ems_object_storage_view ems_object_storage_show_list
                               ems_object_storage_show ems_object_storage_timeline ems_object_storage_control
                               ems_object_storage_tag ems_object_storage_protect ems_object_storage_refresh
                               ems_object_storage_admin ems_object_storage_delete].freeze
  def up
    return if MiqProductFeature.none?

    say_with_time("Enabling ems_storage* product features") do
      block_storage_features = MiqProductFeature.where(:identifier => BLOCK_STORAGE_FEATURES + OBJECT_STORAGE_FEATURES)
      block_storage_features.each do |block_storage_feature|
        block_storage_feature_name = block_storage_feature.identifier
        storage_feature_name       = block_storage_feature_name.gsub(/ems_(block|object)_/, 'ems_')

        storage_feature = MiqProductFeature.find_by(:identifier => storage_feature_name)
        next if storage_feature.nil?

        block_storage_feature.miq_user_roles.each do |user_role|
          # Skip if the user already has the role enabled
          next if user_role.miq_product_features.include?(storage_feature)

          user_role.miq_product_features << storage_feature
          user_role.save!
        end
      end
    end
  end

  # There is no down migration because there is no way to tell if the ems_storage_* features
  # were enabled for a user previously or not.
end
