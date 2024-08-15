require_migration

describe UpdateAutomationProviderUserRoles do
  migration_context :up do
    let(:user_role_stub) { migration_stub(:MiqUserRole) }
    let(:product_feature_stub) { migration_stub(:MiqProductFeature) }

    it "adds 'ems_automation', 'automation_manager_configured_system' and 'configuration_script' to user roles product features with 'automation_manager'" do
      ems_automation = product_feature_stub.create!(
        :name         => "Automation Providers Access Rules",
        :description  => "Access Rules for Automation Providers",
        :feature_type => "node",
        :identifier   => "ems_automation"
      )
      automation_manager_configured_system = product_feature_stub.create!(
        :name         => "Configured Systems Access Rules",
        :description  => "Access Rules for Configured Systems",
        :feature_type => "node",
        :identifier   => "automation_manager_configured_system"
      )
      configuration_script = product_feature_stub.create!(
        :name         => "Templates Access Rules",
        :description  => "Access Rules for Templates",
        :feature_type => "node",
        :identifier   => "configuration_script"
      )
      automation_manager = product_feature_stub.create!(
        :name         => "Ansible Tower Explorer",
        :description  => "Ansible Tower Views",
        :feature_type => "node",
        :identifier   => "automation_manager"
      )
      user_role = user_role_stub.create!(:miq_product_feature_ids => [automation_manager.id], :read_only => false)

      expect(user_role.miq_product_feature_ids).not_to include(ems_automation.id)
      expect(user_role.miq_product_feature_ids).not_to include(automation_manager_configured_system.id)
      expect(user_role.miq_product_feature_ids).not_to include(configuration_script.id)

      migrate
      user_role.reload

      expect(user_role.miq_product_feature_ids).not_to include(automation_manager.id)
      expect(user_role.miq_product_feature_ids).to include(ems_automation.id)
      expect(user_role.miq_product_feature_ids).to include(automation_manager_configured_system.id)
      expect(user_role.miq_product_feature_ids).to include(configuration_script.id)
    end
  end

  migration_context :down do
    let(:user_role_stub) { migration_stub(:MiqUserRole) }
    let(:product_feature_stub) { migration_stub(:MiqProductFeature) }

    it "removes 'ems_automation', 'automation_manager_configured_system' and 'configuration_script' from user roles product features and adds 'automation_manager'" do
      ems_automation = product_feature_stub.create!(
        :name         => "Automation Providers Access Rules",
        :description  => "Access Rules for Automation Providers",
        :feature_type => "node",
        :identifier   => "ems_automation"
      )
      automation_manager_configured_system = product_feature_stub.create!(
        :name         => "Configured Systems Access Rules",
        :description  => "Access Rules for Configured Systems",
        :feature_type => "node",
        :identifier   => "automation_manager_configured_system"
      )
      configuration_script = product_feature_stub.create!(
        :name         => "Templates Access Rules",
        :description  => "Access Rules for Templates",
        :feature_type => "node",
        :identifier   => "configuration_script"
      )
      automation_manager = product_feature_stub.create!(
        :name         => "Ansible Tower Explorer",
        :description  => "Ansible Tower Views",
        :feature_type => "node",
        :identifier   => "automation_manager"
      )
      user_role = user_role_stub.create!(:miq_product_feature_ids => [ems_automation.id, automation_manager_configured_system.id, configuration_script.id], :read_only => false)

      expect(user_role.miq_product_feature_ids).to include(ems_automation.id)
      expect(user_role.miq_product_feature_ids).to include(automation_manager_configured_system.id)
      expect(user_role.miq_product_feature_ids).to include(configuration_script.id)
      expect(user_role.miq_product_feature_ids).not_to include(automation_manager.id)

      migrate
      user_role.reload

      expect(user_role.miq_product_feature_ids).to include(automation_manager.id)
      expect(user_role.miq_product_feature_ids).not_to include(ems_automation.id)
      expect(user_role.miq_product_feature_ids).not_to include(automation_manager_configured_system.id)
      expect(user_role.miq_product_feature_ids).not_to include(configuration_script.id)
    end
  end
end
