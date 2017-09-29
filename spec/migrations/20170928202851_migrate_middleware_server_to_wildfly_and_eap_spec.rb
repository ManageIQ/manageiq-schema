require_migration

describe MigrateMiddlewareServerToWildflyAndEap do
  let(:mw_server_stub) { migration_stub(:MiddlewareServer) }

  migration_context :up do
    it "sets new type for WildFly server" do
      mw_server = mw_server_stub.create!(
        :type    => "ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServer",
        :product => "WildFly Full"
      )
      migrate
      expect(mw_server.reload).to have_attributes(
        :type => "ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServerWildfly"
      )
    end

    it "sets new type for EAP server" do
      mw_server = mw_server_stub.create!(
        :type    => "ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServer",
        :product => "JBoss EAP"
      )
      migrate
      expect(mw_server.reload).to have_attributes(
        :type => "ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServerEap"
      )
    end

    it "leave type unchanged for other mw servers" do
      mw_server = mw_server_stub.create!(
        :type    => "ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServer",
        :product => "Hawkular"
      )
      migrate
      expect(mw_server.reload).to have_attributes(
        :type => "ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServer"
      )
    end
  end

  migration_context :down do
    it "reverts type for WildFly" do
      mw_server = mw_server_stub.create!(:type => "ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServerWildfly")
      migrate
      expect(mw_server.reload).to have_attributes(:type => "ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServer")
    end

    it "reverts type for EAP server" do
      mw_server = mw_server_stub.create!(:type => "ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServerEap")
      migrate
      expect(mw_server.reload).to have_attributes(:type => "ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServer")
    end
  end
end
