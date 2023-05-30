require_migration

describe DeleteForemanProvisioningRefreshSettings do
  let(:settings_change_stub) { migration_stub(:SettingsChange) }

  migration_context :up do
    it "Deletes Foreman ProvisioningManager Refresh settings" do
      settings_change_stub.create(:key => "/ems_refresh/foreman_provisioning/refresh_interval", :value => "30.minutes")
      migrate
      expect(settings_change_stub.count).to be_zero
    end

    it "Doesn't impact unrelated settings" do
      settings_change_stub.create(:key => "/ems_refresh/foreman_configuration/refresh_interval", :value => "30.minutes")
      migrate
      expect(settings_change_stub.count).to eq(1)
    end
  end
end
