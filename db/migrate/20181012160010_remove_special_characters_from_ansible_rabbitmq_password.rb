require 'securerandom'

class RemoveSpecialCharactersFromAnsibleRabbitmqPassword < ActiveRecord::Migration[5.0]
  # used only in specs
  class MiqDatabase < ActiveRecord::Base; end

  class Authentication < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    include ActiveRecord::IdRegions
  end

  def up
    auth = Authentication.in_my_region.find_by(
      :name     => "Ansible Rabbitmq Authentication",
      :authtype => "ansible_rabbitmq_auth",
      :userid   => "ansible",
      :type     => "AuthUseridPassword"
    )

    return unless auth

    current = MiqPassword.decrypt(auth.password)
    auth.update_attributes!(:password => MiqPassword.encrypt(SecureRandom.hex(18))) unless current =~ /^[a-zA-Z0-9]+$/
  end
end
