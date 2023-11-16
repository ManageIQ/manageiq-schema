class AddMySettingsViewToRoles < ActiveRecord::Migration[6.1]
  class MiqUserRole < ActiveRecord::Base
    has_and_belongs_to_many :miq_product_features, :join_table => :miq_roles_features, :class_name => "AddMySettingsViewToRoles::MiqProductFeature"
  end

  class MiqProductFeature < ActiveRecord::Base; end

  def up
    return unless MiqUserRole.exists?(:read_only => false)

    say_with_time("Adding my_settings_view to custom user roles") do
      my_settings_features = MiqProductFeature.where("identifier LIKE ?", "my_settings_%").pluck(:identifier)
      my_settings_view = my_settings_id = nil

      roles_with_features(my_settings_features)
        .where.not(:id => roles_with_features(%w[my_settings my_settings_view]))
        .each do |user_role|
          my_settings_id ||= MiqProductFeature.find_by(:identifier => "my_settings").id

          # This migration will likely run before the product feature is seeded so we need to manually insert it otherwise
          my_settings_view ||= MiqProductFeature.create_with(
            :name         => "View",
            :description  => "View My Settings",
            :feature_type => "view",
            :protected    => false,
            :parent_id    => my_settings_id,
            :hidden       => nil,
            :tenant_id    => nil
          ).find_or_create_by(
            :identifier => "my_settings_view"
          )

          user_role.miq_product_features << my_settings_view
        end
    end
  end

  private

  # Bring back all custom user roles that have the given feature_identifiers
  def roles_with_features(feature_identifiers)
    MiqUserRole
      .joins(:miq_product_features)
      .where(:read_only => false, :miq_product_features => {:identifier => feature_identifiers})
  end
end
