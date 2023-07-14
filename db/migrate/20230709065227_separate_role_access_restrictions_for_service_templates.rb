class SeparateRoleAccessRestrictionsForServiceTemplates < ActiveRecord::Migration[6.0]
  class MiqUserRole < ActiveRecord::Base
    serialize :settings
  end

  def up
    say_with_time("Updating MiqUserRole restictions so Service Templates match existing VMs") do
      MiqUserRole.where(:read_only => false).where("settings LIKE '%vms: :user%'").find_each do |role|
        role.settings[:restrictions][:service_templates] = role.settings.dig(:restrictions, :vms)
        role.save!
      end
    end
  end

  def down
    say_with_time("Remove Service Templates from MiqUserRole restictions") do
      MiqUserRole.where(:read_only => false).where("settings LIKE '%service_templates:%'").find_each do |role|
        role.settings[:restrictions].delete(:service_templates)
        if role.settings[:restrictions] == {} && role.settings.length == 1
          role.settings = nil
        end
        role.save!
      end
    end
  end
end
