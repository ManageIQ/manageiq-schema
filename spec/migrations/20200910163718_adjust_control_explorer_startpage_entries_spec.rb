require_migration

describe AdjustControlExplorerStartpageEntries do
  let(:user_stub) { migration_stub :User }

  migration_context :up do
    describe 'starting page replace' do
      it 'replaces user starting page if control/explorer' do
        user = user_stub.create!(:settings => {:display => {:startpage => 'control/explorer'}})

        migrate
        user.reload

        expect(user.settings[:display][:startpage]).to eq('miq_policy_set/explorer')
      end
    end

    it 'does not affect users without settings' do
      user = user_stub.create!

      migrate

      expect(user_stub.find(user.id)).to eq(user)
    end
  end

  migration_context :down do
    describe 'starting page replace' do
      it "replaces user starting page to control/explorer if miq_policy_set/explorer" do
        user = user_stub.create!(:settings => {:display => {:startpage => 'miq_policy_set/explorer'}})

        migrate
        user.reload

        expect(user.settings[:display][:startpage]).to eq('control/explorer')
      end

      it 'does not affect users without settings' do
        user = user_stub.create!

        migrate

        expect(user_stub.find(user.id)).to eq(user)
      end
    end
  end
end
