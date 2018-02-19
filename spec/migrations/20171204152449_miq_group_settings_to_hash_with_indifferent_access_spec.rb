require_migration

describe MiqGroupSettingsToHashWithIndifferentAccess do
  let(:miq_group_stub) { migration_stub :MiqGroup }

  migration_context :up do
    it "Migrates Hashes to HashWithIndifferentAccess" do
      group1 = miq_group_stub.create!
      group2 = miq_group_stub.create!(:settings => {:a => 1})
      group3 = miq_group_stub.create!(:settings => {:b => 2}.with_indifferent_access)

      expect(group1.settings).to be(nil)
      expect(group2.settings).to be_kind_of(Hash)
      expect(group3.settings).to be_kind_of(ActiveSupport::HashWithIndifferentAccess)

      migrate

      expect(group1.reload.settings).to be(nil)
      expect(group2.reload.settings).to be_kind_of(ActiveSupport::HashWithIndifferentAccess)
      expect(group3.reload.settings).to be_kind_of(ActiveSupport::HashWithIndifferentAccess)
    end
  end
end
