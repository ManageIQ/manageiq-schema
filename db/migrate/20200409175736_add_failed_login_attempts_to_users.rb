class AddFailedLoginAttemptsToUsers < ActiveRecord::Migration[5.1]
  class User < ActiveRecord::Base; end

  def up
    add_column :users, :failed_login_attempts, :integer

    say_with_time 'Zeroing failed_login_attempts for all users' do
      User.update_all(:failed_login_attempts => 0)
    end
  end

  def down
    remove_column :users, :failed_login_attempts
  end
end
