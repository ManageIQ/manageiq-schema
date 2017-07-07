require_migration

describe UpdateContainerTemplateTypes do
  let(:container_template_stub) { migration_stub(:ContainerTemplate) }

  migration_context :up do
    it "setting type correctly" do
      container_template = container_template_stub.create!

      migrate

      expect(container_template.reload).to have_attributes(:type => "ManageIQ::Providers::Openshift::ContainerManager::ContainerTemplate")
    end
  end
end
