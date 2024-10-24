class ReencryptPasswordScramsha < ActiveRecord::Migration[6.1]
  def up
    say_with_time('Reencrypting database user password with scram-sha-256') do
      db_config = ActiveRecord::Base.connection_db_config.configuration_hash
      return if db_config[:username].blank? || db_config[:password].blank?

      username = db_config[:username]
      password = connection.raw_connection.encrypt_password(db_config[:password], username, "scram-sha-256")

      connection.execute <<-SQL
        ALTER ROLE #{username} WITH PASSWORD '#{password}';
      SQL
    end
  end
end
