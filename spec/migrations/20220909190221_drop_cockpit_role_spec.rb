require_migration

describe DropCockpitRole do
  let(:settings_change_stub) { migration_stub(:SettingsChange) }

  migration_context :up do
    it "removes roles in the beginning" do
      only  = settings_change_stub.create!(:key => "/server/role", :value => "ws_cockpit")
      first = settings_change_stub.create!(:key => "/server/role", :value => "ws_cockpit,database,websocket")
      middle = settings_change_stub.create!(:key => "/server/role", :value => "database,ws_cockpit,websocket")
      last  = settings_change_stub.create!(:key => "/server/role", :value => "database,websocket,ws_cockpit")
      none  = settings_change_stub.create!(:key => "/server/role", :value => "database,websocket")

      migrate

      expect(settings_change_stub.exists?(:id => only.id)).to eq(false)
      expect(first.reload.value).to eq("database,websocket")
      expect(middle.reload.value).to eq("database,websocket")
      expect(last.reload.value).to  eq("database,websocket")
      expect(none.reload.value).to  eq("database,websocket")
    end
  end
end
