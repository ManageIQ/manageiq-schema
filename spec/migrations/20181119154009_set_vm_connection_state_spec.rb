require_migration

describe SetVmConnectionState do
  let(:vm_stub)          { migration_stub(:VmOrTemplate) }
  let!(:vm)              { vm_stub.create!(:connection_state => connection_state) }
  let(:connection_state) { nil }

  migration_context :up do
    context 'connection_state is nil' do
      it 'flips to "connected"' do
        migrate
        vm.reload
        expect(vm.connection_state).to eq('connected')
      end
    end

    context 'vm is disconnected' do
      let(:connection_state) { 'disconnected' }
      it 'disconnected stays disconnected' do
        migrate
        vm.reload
        expect(vm.connection_state).to eq(connection_state)
      end
    end
  end
end
