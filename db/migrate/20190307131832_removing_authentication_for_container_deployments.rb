class RemovingAuthenticationForContainerDeployments < ActiveRecord::Migration[5.0]
  class Authentication < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
  end

  def up
    say_with_time("Removing Authentications") do
      Authentication.where(:type => 'AuthenticationAllowAll').delete_all
      Authentication.where(:type => 'AuthenticationGithub').delete_all
      Authentication.where(:type => 'AuthenticationGoogle').delete_all
      Authentication.where(:type => 'AuthenticationHtpasswd').delete_all
      Authentication.where(:type => 'AuthenticationLdap').delete_all
      Authentication.where(:type => 'AuthenticationOpenId').delete_all
      Authentication.where(:type => 'AuthenticationRequestHeader').delete_all
      Authentication.where(:type => 'AuthenticationRhsm').delete_all
    end
  end
end
