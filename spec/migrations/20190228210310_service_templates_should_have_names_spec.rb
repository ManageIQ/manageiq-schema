require_migration

describe ServiceTemplatesShouldHaveNames do
  let(:service_template) { migration_stub(:ServiceTemplate) }

  migration_context :up do
    it "sets template_names" do
      obj1 = service_template.create!
      obj2 = service_template.create!(:name => "")

      expect(obj1.reload.name).to eq(nil)
      expect(obj2.reload.name).to eq("")

      migrate

      expect(obj1.reload.name).not_to eq(nil)
      expect(obj2.reload.name).not_to eq("")
    end
  end
end
