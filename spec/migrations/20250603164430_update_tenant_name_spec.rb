require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe UpdateTenantName do
  let(:settings_change_stub) { migration_stub(:SettingsChange) }
  let(:tenant_stub) { migration_stub(:Tenant) }

  migration_context :up do
    it "doesn't update tenant name if it is not use_config_for_attributes" do
      rt = tenant_stub.create(:ancestry => nil, :name => "GoodName", :use_config_for_attributes => false)
      chld = tenant_stub.create(:ancestry => rt.id.to_s, :name => "GoodName2", :use_config_for_attributes => false)

      expect(settings_change_stub.count).to eq(0)
      settings_change_stub.create(:key => "/server/company", :value => "BadName")
      settings_change_stub.create(:key => "/server/other", :value => "Other")

      migrate

      expect(settings_change_stub.count).to eq(1)
      expect(rt.reload.name).to eq("GoodName")
      expect(rt.use_config_for_attributes).to eq(false)
      expect(chld.reload.name).to eq("GoodName2")
    end

    it "updates tenant name if it is use_config_for_attributes" do
      rt = tenant_stub.create(:ancestry => nil, :name => nil, :use_config_for_attributes => true)
      chld = tenant_stub.create(:ancestry => rt.id.to_s, :name => "GoodName2", :use_config_for_attributes => false)

      expect(settings_change_stub.count).to eq(0)
      settings_change_stub.create(:key => "/server/company", :value => "GoodName")
      settings_change_stub.create(:key => "/server/other", :value => "Other")

      migrate

      expect(settings_change_stub.count).to eq(1)
      expect(rt.reload.name).to eq("GoodName")
      expect(rt.use_config_for_attributes).to eq(false)
      expect(chld.reload.name).to eq("GoodName2")
    end

    it "updates tenant name to default if it is use_config_for_attributes but no name is in settings" do
      rt = tenant_stub.create(:ancestry => nil, :name => nil, :use_config_for_attributes => true)
      chld = tenant_stub.create(:ancestry => rt.id.to_s, :name => "GoodName2", :use_config_for_attributes => false)

      migrate

      expect(rt.reload.name).to eq("My Company")
      expect(rt.use_config_for_attributes).to eq(false)
      expect(chld.reload.name).to eq("GoodName2")
    end
  end
end
