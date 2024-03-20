require_migration

describe AddGuidToMiqEnterprise do
  let(:miq_enterprise_stub) { migration_stub(:MiqEnterprise) }

  migration_context :up do
    it "adds a guid column and value to MiqEnterprise" do
      miq_enterprise = miq_enterprise_stub.create!

      migrate

      expect(miq_enterprise.reload.guid).to be_guid
    end
  end

  migration_context :down do
    it "removes guid column from MiqEnterprise" do
      miq_enterprise = miq_enterprise_stub.create!(:name => "test", :description => "test enterprise", :guid => SecureRandom.uuid)

      migrate

      expect(miq_enterprise.reload).to have_attributes(:name => "test", :description => "test enterprise")
    end
  end
end
