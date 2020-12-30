require_migration

describe UpdateStartpageShortcutAfterActionsDeExplorization do
  let(:user_stub) { migration_stub :User }

  migration_context :up do
    describe 'start page update' do
      it 'update user start page if miq_action/explorer' do
        user = user_stub.create!(:settings => {:display => {:startpage => 'miq_action/explorer'}})

        migrate
        user.reload

        expect(user.settings[:display][:startpage]).to eq('miq_action/show_list')
      end
    end

    it 'does not affect users without settings' do
      user = user_stub.create!

      migrate

      expect(user_stub.find(user.id)).to eq(user)
    end
  end

  migration_context :down do
    describe 'start page revert' do
      it "revert user start page to miq_action/explorer" do
        user = user_stub.create!(:settings => {:display => {:startpage => 'miq_action/show_list'}})

        migrate
        user.reload

        expect(user.settings[:display][:startpage]).to eq('miq_action/explorer')
      end

      it 'does not affect users without settings' do
        user = user_stub.create!

        migrate

        expect(user_stub.find(user.id)).to eq(user)
      end
    end
  end
end
