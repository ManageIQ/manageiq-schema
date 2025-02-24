require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe MoveBlacklistedEventsToSettingsChanges do
  let(:blacklisted_event_stub) { migration_stub(:BlacklistedEvent) }
  let(:miq_region_stub)        { migration_stub(:MiqRegion) }
  let(:settings_change_stub)   { migration_stub(:SettingsChange) }
  let!(:my_region)             { miq_region_stub.create!(:region => miq_region_stub.my_region_number) }

  migration_context :up do
    it "with only default blacklisted events" do
      blacklisted_event_stub.create!(:provider_model => "ManageIQ::Providers::Vmware::InfraManager", :event_name => "UserLoginSessionEvent",  :system => true, :enabled => true)
      blacklisted_event_stub.create!(:provider_model => "ManageIQ::Providers::Vmware::InfraManager", :event_name => "UserLogoutSessionEvent", :system => true, :enabled => true)

      migrate

      expect(settings_change_stub.count).to be_zero
    end

    it "with defualt blacklisted events and user created events" do
      blacklisted_event_stub.create!(:provider_model => "ManageIQ::Providers::Vmware::InfraManager", :event_name => "UserLoginSessionEvent",  :system => true,  :enabled => true)
      blacklisted_event_stub.create!(:provider_model => "ManageIQ::Providers::Vmware::InfraManager", :event_name => "UserLogoutSessionEvent", :system => true,  :enabled => true)
      blacklisted_event_stub.create!(:provider_model => "ManageIQ::Providers::Vmware::InfraManager", :event_name => "MySpecialEvent",         :system => false, :enabled => true)

      migrate

      expect(settings_change_stub.count).to eq(1)
      expect(settings_change_stub.first).to have_attributes(
        :resource_type => "MiqRegion",
        :resource_id   => my_region.id,
        :key           => "/ems/ems_vmware/blacklisted_event_names",
        :value         => array_including("MySpecialEvent")
      )
    end

    it "with disabled user created events" do
      blacklisted_event_stub.create!(:provider_model => "ManageIQ::Providers::Vmware::InfraManager", :event_name => "UserLoginSessionEvent",  :system => true,  :enabled => true)
      blacklisted_event_stub.create!(:provider_model => "ManageIQ::Providers::Vmware::InfraManager", :event_name => "UserLogoutSessionEvent", :system => true,  :enabled => true)
      blacklisted_event_stub.create!(:provider_model => "ManageIQ::Providers::Vmware::InfraManager", :event_name => "MySpecialEvent",         :system => false, :enabled => false)

      migrate

      expect(settings_change_stub.count).to be_zero
    end
  end

  migration_context :down do
    it "with only default blacklisted events" do
      settings_change_stub.create!(:key => "/ems/ems_vmware/blacklisted_event_names", :value => %w[UserLoginSessionEvent UserLogoutSessionEvent])

      migrate

      expect(blacklisted_event_stub.count).to be_zero
    end

    it "with defualt blacklisted events and user created events" do
      settings_change_stub.create!(:key => "/ems/ems_vmware/blacklisted_event_names", :value => %w[UserLoginSessionEvent UserLogoutSessionEvent MySpecialEvent])

      migrate

      expect(blacklisted_event_stub.count).to eq(1)
    end
  end
end
