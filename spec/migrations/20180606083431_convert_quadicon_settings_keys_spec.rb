require_migration

describe ConvertQuadiconSettingsKeys do
  let(:user_stub) { migration_stub :User }

  migration_context :up do
    it 'moves the value of :ems to :ems_infra' do
      user = user_stub.create!(:settings => {:quadicons => {:ems => false }})

      migrate

      user.reload

      expect(user.settings[:quadicons][:ems]).to be_nil
      expect(user.settings[:quadicons][:ems_infra]).to be_falsey
    end

    it 'skips the user when the quadicons are not set' do
      user = user_stub.create!

      migrate

      user.reload

      expect(user.settings).to eq({})
    end
  end

  migration_context :down do
    it 'moves the value of :ems to :ems_infra' do
      user = user_stub.create!(:settings => {:quadicons => {:ems_infra => false }})

      migrate

      user.reload

      expect(user.settings[:quadicons][:ems_infra]).to be_nil
      expect(user.settings[:quadicons][:ems]).to be_falsey
    end

    it 'skips the user when the quadicons are not set' do
      user = user_stub.create!

      migrate

      user.reload

      expect(user.settings).to eq({})
    end
  end
end
