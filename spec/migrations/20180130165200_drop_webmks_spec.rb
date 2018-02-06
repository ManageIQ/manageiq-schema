require_migration

describe DropWebmks do
  let(:server_stub)   { migration_stub(:MiqServer) }
  let(:settings_stub) { migration_stub(:SettingsChange) }

  migration_context :up do
    let(:server) { server_stub.create }

    it 'resets the remote_console_type to default' do
      settings_stub.create(:resource_id => server.id, :resource_type => server.class, :key => '/server/remote_console_type', :value => 'MKS')
      migrate

      expect(settings_stub.where(:key => '/server/remote_console_type', :value => 'MKS')).not_to exist
    end
  end
end
