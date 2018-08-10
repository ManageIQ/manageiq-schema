require_migration

describe UpdateDefaultInternalAttribute do
  let(:service_template_stub) { migration_stub(:ServiceTemplate) }

  migration_context :up do
    it "sets internal to false when type is ServiceTemplateTransformationPlan" do
      st = service_template_stub.create!(:type => 'ServiceTemplateTransformationPlan', :internal => true)

      migrate

      expect(st.reload.internal).to be_truthy
    end

    it "sets internal to false when type is not ServiceTemplateTransformationPlan" do
      st = service_template_stub.create!(:type => 'OtherServiceTemplateTransformationPlan')

      migrate

      expect(st.reload.internal).to be(false)
    end
  end
end
