require_migration

describe CheckGuidUniqueness do
  let(:automate_workspace) { migration_stub(:AutomateWorkspace) }
  let(:miq_ae_workspace) { migration_stub(:MiqAeWorkspace) }
  let(:miq_policy) { migration_stub(:MiqPolicy) }
  let(:miq_region) { migration_stub(:MiqRegion) }
  let(:miq_widget) { migration_stub(:MiqWidget) }
  let(:service) { migration_stub(:Service) }
  let(:service_template) { migration_stub(:ServiceTemplate) }

  migration_context :up do
    %i[automate_workspace miq_ae_workspace miq_policy miq_region miq_widget service service_template].each do |obj|
      it "#{obj} dup resets guid" do
        guid = SecureRandom.uuid
        klass = send(obj)
        obj1 = klass.create!(:guid => guid)
        obj2 = klass.new(:guid => guid)
        obj2.save(:validate => false)
        obj3 = klass.create!(:guid => SecureRandom.uuid)
        guid2 = obj3.guid

        expect(obj1.reload.guid).to eq(guid)
        expect(obj2.reload.guid).to eq(guid)

        migrate

        expect(obj1.reload.guid).to eq(guid)
        expect(obj2.reload.guid).not_to eq(guid)
        expect(obj3.reload.guid).to eq(guid2)
      end
    end
  end
end
