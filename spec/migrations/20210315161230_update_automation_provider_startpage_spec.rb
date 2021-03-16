require_migration

describe UpdateAutomationProviderStartpage do
  let(:user_stub) { migration_stub :User }

  migration_context :up do
    describe 'starting page update' do
      it 'update user start page if automation_manager/explorer' do
        user = user_stub.create!(:settings => {:display => {:startpage => 'automation_manager/explorer'}})

        migrate
        user.reload

        expect(user.settings[:display][:startpage]).to eq('ems_automation/show_list')
      end
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

  migration_context :down do
    describe 'revert start page' do
      it "reverts user start page to automation_manager/explorer from mes_automation/show_list" do
        user = user_stub.create!(:settings => {:display => {:startpage => 'ems_automation/show_list'}})

        migrate
        user.reload

        expect(user.settings[:display][:startpage]).to eq('automation_manager/explorer')
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
