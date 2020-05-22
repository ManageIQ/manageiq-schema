require_migration

describe UpdateChargebackAssignmentsStartpage do
  let(:user_stub) { migration_stub :User }

  migration_context :up do
    describe 'starting page replace' do
      it 'replaces user starting page if chargeback_assignments/explorer' do
        user = user_stub.create!(:settings => {:display => {:startpage => 'chargeback_assignments/explorer'}})

        migrate
        user.reload

        expect(user.settings[:display][:startpage]).to eq('chargeback_assignment')
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
      it "replaces user starting page to chargeback_assignments/explorer if chargeback_assignment" do
        user = user_stub.create!(:settings => {:display => {:startpage => 'chargeback_assignment'}})

        migrate
        user.reload

        expect(user.settings[:display][:startpage]).to eq('chargeback_assignments/explorer')
      end

      it 'does not affect users without settings' do
        user = user_stub.create!

        migrate

        expect(user_stub.find(user.id)).to eq(user)
      end
    end
  end
end
