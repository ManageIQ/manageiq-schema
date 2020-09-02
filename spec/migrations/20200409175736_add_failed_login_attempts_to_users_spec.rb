require_migration

describe AddFailedLoginAttemptsToUsers do
  let(:user_stub) { migration_stub(:User) }
  let(:user) { user_stub.create(:name => 'test', :userid => 'test') }

  migration_context :up do
    it 'creates a new field which defaults to 0' do
      expect(user).to_not respond_to(:failed_login_attempts)

      migrate
      user.reload

      expect(user.failed_login_attempts).to eq(0)
    end
  end
end
