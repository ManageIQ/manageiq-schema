require_migration

describe AddServiceTemplateNameUniqValidation do
  let(:template) { migration_stub(:ServiceTemplate) }

  migration_context :up do
    it "ServiceTemplate dup resets name" do
      name1 = SecureRandom.uuid
      obj1 = template.create!(:name => name1)
      obj2 = template.new(:name => name1)

      obj2.save(:validate => false)
      obj3 = template.create!(:name => SecureRandom.uuid)
      name2 = obj3.name

      expect(obj1.reload.name).to eq(name1)
      expect(obj2.reload.name).to eq(name1)

      migrate

      expect(obj1.reload.name).to eq(name1)
      expect(obj2.reload.name).not_to eq(name1)
      expect(obj3.reload.name).to eq(name2)
    end
  end
end
