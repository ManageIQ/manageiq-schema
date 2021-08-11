require_migration

describe RemoveUpdateRepoNamesFromSettings do
  let(:settings_change) { migration_stub(:SettingsChange) }

  migration_context :up do
    it "deletes only desired key" do
      settings_change.create!(:resource_type => "MiqRegion", :key => "/product/update_repo_names")

      migrate

      expect(settings_change.count).to eq(0)
    end

    it "leaves" do
      settings_change.create!(:resource_type => "MiqRegion", :key => "/product/keep_me")
      settings_change.create!(:resource_type => "MiqServer", :key => "/product/keep_me_too")

      migrate

      expect(settings_change.count).to eq(2)
    end
  end
end
