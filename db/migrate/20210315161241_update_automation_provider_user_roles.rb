class UpdateAutomationProviderUserRoles < ActiveRecord::Migration[6.0]
  class MiqUserRole < ActiveRecord::Base
    has_and_belongs_to_many :miq_product_features, :join_table => :miq_roles_features, :class_name => "UpdateAutomationProviderUserRoles::MiqProductFeature"
  end

  class MiqProductFeature < ActiveRecord::Base; end

  def up
    say_with_time "Correcting user created role feature sets" do
      automation_manager                   = MiqProductFeature.find_by(:identifier => "automation_manager")
      ems_automation                       = MiqProductFeature.find_by(:identifier => "ems_automation")
      automation_manager_configured_system = MiqProductFeature.find_by(:identifier => "automation_manager_configured_system")
      configuration_script                 = MiqProductFeature.find_by(:identifier => "configuration_script")

      affected_user_roles.each do |user_role|
        if user_role.miq_product_features.include?(automation_manager)
          user_role.miq_product_features << ems_automation
          user_role.miq_product_features << automation_manager_configured_system
          user_role.miq_product_features << configuration_script
          user_role.miq_product_features.delete(automation_manager)
        end

        user_role.save!
      end
    end
  end

  def down
    say_with_time "Reverting user created role feature sets" do
      automation_manager                   = MiqProductFeature.find_by(:identifier => "automation_manager")
      ems_automation                       = MiqProductFeature.find_by(:identifier => "ems_automation")
      automation_manager_configured_system = MiqProductFeature.find_by(:identifier => "automation_manager_configured_system")
      configuration_script                 = MiqProductFeature.find_by(:identifier => "configuration_script")

      %w(ems_automation automation_manager_configured_system configuration_script).each do |feature|
        roles_to_revert(feature).each do |user_role|
          user_role.miq_product_features.delete(ems_automation) if user_role.miq_product_features.include?(ems_automation)
          user_role.miq_product_features.delete(automation_manager_configured_system) if user_role.miq_product_features.include?(automation_manager_configured_system)
          user_role.miq_product_features.delete(configuration_script) if user_role.miq_product_features.include?(configuration_script)
          user_role.miq_product_features << automation_manager
          user_role.save!
        end
        end
    end
  end

  def roles_to_revert(feature)
    MiqUserRole
      .includes(:miq_product_features)
      .where(:read_only => false, :miq_product_features => {:identifier => feature})
  end

  def affected_user_roles
    MiqUserRole
      .includes(:miq_product_features)
      .where(:read_only => false, :miq_product_features => {:identifier => %w(automation_manager)})
  end
end
