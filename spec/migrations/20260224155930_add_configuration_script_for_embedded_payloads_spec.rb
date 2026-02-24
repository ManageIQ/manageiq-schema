require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe AddConfigurationScriptForEmbeddedPayloads do
  let(:configuration_script_base_stub) { migration_stub(:ConfigurationScriptBase) }

  migration_context :up do
    it "creates EmbeddedAnsible and EmbeddedTerraform ConfigurationScripts" do
      embedded_ansible_playbook   = configuration_script_base_stub.create!(:type => "ManageIQ::Providers::EmbeddedAnsible::AutomationManager::Playbook", :name => "playbook.yml")
      embedded_terraform_template = configuration_script_base_stub.create!(:type => "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Template", :name => "template.yml")

      migrate

      expect(configuration_script_base_stub.count).to eq(4)

      expect(configuration_script_base_stub.find_by(:type => "ManageIQ::Providers::EmbeddedAnsible::AutomationManager::ConfigurationScript")).to have_attributes(
        :name      => "playbook.yml",
        :parent_id => embedded_ansible_playbook.id
      )

      expect(configuration_script_base_stub.find_by(:type => "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::ConfigurationScript")).to have_attributes(
        :name      => "template.yml",
        :parent_id => embedded_terraform_template.id
      )
    end

    it "ignores other ConfigurationScriptPayloads" do
      configuration_script_base_stub.create!(:type => "ManageIQ::Providers::AnsibleTower::AutomationManager::Playbook", :name => "playbook.yml")

      migrate

      expect(configuration_script_base_stub.count).to eq(1)
    end
  end

  migration_context :down do
    it "deletes EmbeddedAutomation ConfigurationScripts" do
      configuration_script_base_stub.create!(:type => "ManageIQ::Providers::EmbeddedAnsible::AutomationManager::Playbook", :name => "playbook.yml")
      configuration_script_base_stub.create!(:type => "ManageIQ::Providers::EmbeddedAnsible::AutomationManager::ConfigurationScript", :name => "playbook.yml")
      configuration_script_base_stub.create!(:type => "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Template", :name => "template.yml")
      configuration_script_base_stub.create!(:type => "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::ConfigurationScript", :name => "template.yml")

      migrate

      expect(configuration_script_base_stub.where(:type => ["ManageIQ::Providers::EmbeddedAnsible::AutomationManager::ConfigurationScript", "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::ConfigurationScript"]).count).to be_zero
    end

    it "ignores other ConfigurationScripts" do
      configuration_script_base_stub.create!(:type => "ManageIQ::Providers::AnsibleTower::AutomationManager::ConfigurationScript", :name => "playbook.yml")

      migrate

      expect(configuration_script_base_stub.count).to eq(1)
    end
  end
end
