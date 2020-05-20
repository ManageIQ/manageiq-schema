require_migration

describe UpdateChargebackReportsStartpage do
  let(:user_stub) { migration_stub :User }

  migration_context :up do
    describe 'starting page replace' do
      it 'replaces user starting page if chargeback_reports/explorer' do
        user = user_stub.create!(:settings => {:display => {:startpage => 'chargeback_reports/explorer'}})

        migrate
        user.reload

        expect(user.settings[:display][:startpage]).to eq('chargeback_report/show_list')
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
      it "replaces user starting page to chargeback_reports/explorer if chargeback_report/show_list" do
        user = user_stub.create!(:settings => {:display => {:startpage => 'chargeback_report/show_list'}})

        migrate
        user.reload

        expect(user.settings[:display][:startpage]).to eq('chargeback_reports/explorer')
      end

      it 'does not affect users without settings' do
        user = user_stub.create!

        migrate

        expect(user_stub.find(user.id)).to eq(user)
      end
    end
  end
end
