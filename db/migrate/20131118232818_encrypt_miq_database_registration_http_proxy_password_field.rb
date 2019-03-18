class EncryptMiqDatabaseRegistrationHttpProxyPasswordField < ActiveRecord::Migration[4.2]
  class MiqDatabase < ActiveRecord::Base; end

  def up
    say_with_time("Encrypt miq_database registration_http_proxy_password field") do
      MiqDatabase.all.each do |db|
        db.update_attribute(:registration_http_proxy_password, ManageIQ::Password.encrypt(db.registration_http_proxy_password)) unless ManageIQ::Password.encrypted?(db.registration_http_proxy_password)
      end
    end
  end

  def down
    say_with_time("Decrypt miq_database registration_http_proxy_password field") do
      MiqDatabase.all.each do |db|
        db.update_attribute(:registration_http_proxy_password, ManageIQ::Password.decrypt(db.registration_http_proxy_password)) if ManageIQ::Password.encrypted?(db.registration_http_proxy_password)
      end
    end
  end
end
