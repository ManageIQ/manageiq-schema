require_migration

describe UpdatePolicyStartpageUrlAfterDeExplorization do
  let(:user_stub) { migration_stub :User }

  migration_context :up do
    describe 'starting page update' do
      it 'update user start page if miq_policy/explorer' do
        user = user_stub.create!(:settings => {:display => {:startpage => 'miq_policy/explorer'}})

        migrate
        user.reload

        expect(user.settings[:display][:startpage]).to eq('miq_policy/show_list')
      end

      it "user start page remains unchanged if it is set to some other url" do
        user = user_stub.create!(:settings => {:display => {:startpage => 'host/show_list'}})

        migrate
        user.reload

        expect(user.settings[:display][:startpage]).to eq('host/show_list')
      end

      it 'does not affect users without settings' do
        user = user_stub.create!

        migrate

        expect(user_stub.find(user.id)).to eq(user)
      end
    end
  end

  migration_context :down do
    describe 'revert start page' do
      it "reverts user start page to miq_policy/explorer from miq_policy/show_list" do
        user = user_stub.create!(:settings => {:display => {:startpage => 'miq_policy/show_list'}})

        migrate
        user.reload

        expect(user.settings[:display][:startpage]).to eq('miq_policy/explorer')
      end

      it "user start page remains unchanged if it is set to some other url" do
        user = user_stub.create!(:settings => {:display => {:startpage => 'host/show_list'}})

        migrate
        user.reload

        expect(user.settings[:display][:startpage]).to eq('host/show_list')
      end

      it 'does not affect users without settings' do
        user = user_stub.create!

        migrate

        expect(user_stub.find(user.id)).to eq(user)
      end
    end
  end
end
