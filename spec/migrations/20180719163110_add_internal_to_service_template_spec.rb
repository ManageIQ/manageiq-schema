require_migration

describe AddInternalToServiceTemplate do
  let(:reserve_stub)          { Spec::Support::MigrationStubs.reserved_stub }
  let(:service_template_stub) { migration_stub(:ServiceTemplate) }

  migration_context :up do
    it "migrate reserve data to ServiceTemplate" do
      st = service_template_stub.create!(:type => 'ServiceTemplateTransformationPlan')
      reserve_stub.create!(
        :resource_type => st.class.name,
        :resource_id   => st.id,
        :reserved      => {
          :internal => true,
        }
      )

      migrate

      expect(st.reload.internal).to be_truthy
    end

    it "migrate internal in ServiceTemplate to reserve table" do
      st = service_template_stub.create!(:type => 'ServiceTemplateTransformationPlan')

      migrate

      expect(reserve_stub.count).to eq(1)

      reserved_rec = reserve_stub.first
      expect(reserved_rec.resource_id).to   eq(st.id)
      expect(reserved_rec.resource_type).to eq(st.class.name)

      expect(reserved_rec.reserved[:internal]).to be_truthy
    end
  end
end
