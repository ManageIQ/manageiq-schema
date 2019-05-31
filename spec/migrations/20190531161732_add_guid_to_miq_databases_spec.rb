require_migration

describe AddGuidToMiqDatabases do
  let(:miq_database) { migration_stub(:MiqDatabase) }

  migration_context :up do
    it "sets miq_database guids" do
      db = miq_database.create!

      migrate

      expect(db.reload.guid).to be_guid
    end
  end
end
