require_migration

describe AddInternalToServiceTemplate do
  let(:service_template_stub) { migration_stub(:ServiceTemplate) }

  migration_context :up do
    it "sets internal to true when type is ServiceTemplateTransformationPlan" do
      st = service_template_stub.create!(:type => 'ServiceTemplateTransformationPlan')

      migrate

      expect(st.reload.internal).to be_truthy
    end

    it "skip internal for other types" do
      st = service_template_stub.create!(:type => 'OtherServiceTemplateType')

      migrate

      expect(st.reload.internal).to be_nil
    end
  end
end
