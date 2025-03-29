require_migration

describe SetManagerRefEmbeddedConfigurationScripts do
  let(:configuration_script_stub) { migration_stub(:ConfigurationScript) }

  migration_context :up do
    it "sets the manager_ref for embedded type configuration_scripts" do
      embedded_ansible_playbook  = configuration_script_stub.create!(:type => "ManageIQ::Providers::EmbeddedAnsible::AutomationManager::Playbook", :name => "project/my_playbook.yaml")
      mbedded_workflows_workflow = configuration_script_stub.create!(:type => "ManageIQ::Providers::Workflows::AutomationManager::Workflow", :name => "workflows/my_workflow.yaml")

      migrate

      expect(embedded_ansible_playbook.reload.manager_ref).to eq("project/my_playbook.yaml")
      expect(mbedded_workflows_workflow.reload.manager_ref).to eq("workflows/my_workflow.yaml")
    end

    it "doesn't impact non-embedded configuration_scripts" do
      ansible_tower_playbook = configuration_script_stub.create!(:type => "ManageIQ::Providers::AnsibleTower::AutomationManager::Playbook", :name => "project/my_playbook.yaml", :manager_ref => "123")
      awx_playbook           = configuration_script_stub.create!(:type => "ManageIQ::Providers::Awx::AutomationManager::Playbook", :name => "project/my_playbook.yaml", :manager_ref => "123")

      migrate

      expect(ansible_tower_playbook.reload.manager_ref).to eq("123")
      expect(awx_playbook.reload.manager_ref).to eq("123")
    end
  end

  migration_context :down do
    it "sets the manager_ref back to nil for embedded type configuration_scripts" do
      embedded_ansible_playbook  = configuration_script_stub.create!(:type => "ManageIQ::Providers::EmbeddedAnsible::AutomationManager::Playbook", :name => "project/my_playbook.yaml")
      mbedded_workflows_workflow = configuration_script_stub.create!(:type => "ManageIQ::Providers::Workflows::AutomationManager::Workflow", :name => "workflows/my_workflow.yaml")

      migrate

      expect(embedded_ansible_playbook.reload.manager_ref).to be_nil
      expect(mbedded_workflows_workflow.reload.manager_ref).to be_nil
    end

    it "doesn't impact non-embedded configuration_scripts" do
      ansible_tower_playbook = configuration_script_stub.create!(:type => "ManageIQ::Providers::AnsibleTower::AutomationManager::Playbook", :name => "project/my_playbook.yaml", :manager_ref => "123")
      awx_playbook           = configuration_script_stub.create!(:type => "ManageIQ::Providers::Awx::AutomationManager::Playbook", :name => "project/my_playbook.yaml", :manager_ref => "123")

      migrate

      expect(ansible_tower_playbook.reload.manager_ref).to eq("123")
      expect(awx_playbook.reload.manager_ref).to eq("123")
    end
  end
end
