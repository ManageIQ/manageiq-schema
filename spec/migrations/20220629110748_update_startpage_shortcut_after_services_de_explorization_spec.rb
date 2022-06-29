require_migration

describe UpdateStartpageShortcutAfterServicesDeExplorization do
  let(:user_stub) { migration_stub :User }

  migration_context :up do
    describe 'start page update' do
      it 'update user start page if service/explorer' do
        user = user_stub.create!(:settings => {:display => {:startpage => 'service/explorer'}})

        migrate
        user.reload

        expect(user.settings[:display][:startpage]).to eq('service/show_list')
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
      it "revert user start page to service/explorer" do
        user = user_stub.create!(:settings => {:display => {:startpage => 'service/show_list'}})

        migrate
        user.reload

        expect(user.settings[:display][:startpage]).to eq('service/explorer')
      end

      it 'does not affect users without settings' do
        user = user_stub.create!

        migrate

        expect(user_stub.find(user.id)).to eq(user)
      end
    end
  end
end
