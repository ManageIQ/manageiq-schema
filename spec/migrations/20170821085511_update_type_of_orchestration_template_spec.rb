require_migration

describe UpdateTypeOfOrchestrationTemplate do
  let(:orchestration_template_klass) { migration_stub(:OrchestrationTemplate) }

  migration_context :up do
    it "sets new type for cfn template" do
      orchestration_template = orchestration_template_klass.create!(:type => 'OrchestrationTemplateCfn')
      migrate
      expect(orchestration_template.reload).to have_attributes(:type => "ManageIQ::Providers::Amazon::CloudManager::OrchestrationTemplate")
    end

    it "sets new type for hot template" do
      orchestration_template = orchestration_template_klass.create!(:type => 'OrchestrationTemplateHot')
      migrate
      expect(orchestration_template.reload).to have_attributes(:type => "ManageIQ::Providers::Openstack::CloudManager::OrchestrationTemplate")
    end

    it "sets new type for vnfd template" do
      orchestration_template = orchestration_template_klass.create!(:type => 'OrchestrationTemplateVnfd')
      migrate
      expect(orchestration_template.reload).to have_attributes(:type => "ManageIQ::Providers::Openstack::CloudManager::VnfdTemplate")
    end

    it "sets new type for azure template" do
      orchestration_template = orchestration_template_klass.create!(:type => 'OrchestrationTemplateAzure')
      migrate
      expect(orchestration_template.reload).to have_attributes(:type => "ManageIQ::Providers::Azure::CloudManager::OrchestrationTemplate")
    end
  end

  migration_context :down do
    it "reverts type to cfn template" do
      orchestration_template = orchestration_template_klass.create!(:type => "ManageIQ::Providers::Amazon::CloudManager::OrchestrationTemplate")
      migrate
      expect(orchestration_template.reload).to have_attributes(:type => 'OrchestrationTemplateCfn')
    end

    it "reverts type to hot template" do
      orchestration_template = orchestration_template_klass.create!(:type => "ManageIQ::Providers::Openstack::CloudManager::OrchestrationTemplate")
      migrate
      expect(orchestration_template.reload).to have_attributes(:type => 'OrchestrationTemplateHot')
    end

    it "reverts type to vnfd template" do
      orchestration_template = orchestration_template_klass.create!(:type => "ManageIQ::Providers::Openstack::CloudManager::VnfdTemplate")
      migrate
      expect(orchestration_template.reload).to have_attributes(:type => 'OrchestrationTemplateVnfd')
    end

    it "reverts type to azure template" do
      orchestration_template = orchestration_template_klass.create!(:type => "ManageIQ::Providers::Azure::CloudManager::OrchestrationTemplate")
      migrate
      expect(orchestration_template.reload).to have_attributes(:type => 'OrchestrationTemplateAzure')
    end
  end
end
