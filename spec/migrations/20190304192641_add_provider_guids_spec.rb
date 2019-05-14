require_migration

describe AddProviderGuids do
  let(:provider) { migration_stub(:Provider) }

  migration_context :up do
    it "sets provider guids" do
      obj1 = provider.create!

      expect(obj1.reload.guid).to eq(nil)

      migrate

      expect(obj1.reload.guid).not_to eq(nil)
    end
  end
end
