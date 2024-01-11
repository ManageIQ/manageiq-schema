require_migration

class FixOrchestrationStackConfigurationScriptReference
  class ConfigurationScriptBase < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.table_name         = "configuration_scripts"
    self.inheritance_column = :_type_disabled
  end

  class OrchestrationTemplate < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end
end

describe FixOrchestrationStackConfigurationScriptReference do
  let(:configuration_script_base_stub) { migration_stub(:ConfigurationScriptBase) }
  let(:orchestration_stack_stub)       { migration_stub(:OrchestrationStack) }
  let(:orchestration_template_stub)    { migration_stub(:OrchestrationTemplate) }

  migration_context :up do
    it "fixes AWX and AnsibleTower Jobs" do
      job_template = configuration_script_base_stub.create!(:type => "ConfigurationScript")

      awx_job   = orchestration_stack_stub.create!(:type => "ManageIQ::Providers::Awx::AutomationManager::Job",          :orchestration_template_id => job_template.id)
      tower_job = orchestration_stack_stub.create!(:type => "ManageIQ::Providers::AnsibleTower::AutomationManager::Job", :orchestration_template_id => job_template.id)

      migrate

      awx_job.reload
      tower_job.reload

      expect(awx_job.configuration_script_id).to   eq(job_template.id)
      expect(awx_job.orchestration_template_id).to be_nil

      expect(tower_job.configuration_script_id).to   eq(job_template.id)
      expect(tower_job.orchestration_template_id).to be_nil
    end

    it "doesn't impact other Orchestration Stacks" do
      cloud_template = orchestration_template_stub.create!
      cloud_stack    = orchestration_stack_stub.create!(:type => "ManageIQ::Providers::CloudManager::OrchestrationStack", :orchestration_template_id => cloud_template.id)

      migrate

      cloud_stack.reload

      expect(cloud_stack.orchestration_template_id).to eq(cloud_template.id)
      expect(cloud_stack.configuration_script_id).to   be_nil
    end
  end

  migration_context :down do
    it "resets AWX and AnsibleTower Jobs" do
      job_template = configuration_script_base_stub.create!(:type => "ConfigurationScript")

      awx_job   = orchestration_stack_stub.create!(:type => "ManageIQ::Providers::Awx::AutomationManager::Job",          :configuration_script_id => job_template.id)
      tower_job = orchestration_stack_stub.create!(:type => "ManageIQ::Providers::AnsibleTower::AutomationManager::Job", :configuration_script_id => job_template.id)

      migrate

      awx_job.reload
      tower_job.reload

      expect(awx_job.configuration_script_id).to   be_nil
      expect(awx_job.orchestration_template_id).to eq(job_template.id)

      expect(tower_job.configuration_script_id).to   be_nil
      expect(tower_job.orchestration_template_id).to eq(job_template.id)
    end

    it "doesn't impact other Orchestration Stacks" do
      cloud_template = orchestration_template_stub.create!
      cloud_stack    = orchestration_stack_stub.create!(:type => "ManageIQ::Providers::CloudManager::OrchestrationStack", :orchestration_template_id => cloud_template.id)

      migrate

      cloud_stack.reload

      expect(cloud_stack.orchestration_template_id).to eq(cloud_template.id)
      expect(cloud_stack.configuration_script_id).to   be_nil
    end
  end
end
