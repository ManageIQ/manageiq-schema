class AllowMoreSpecificRestrictionTypesForRoles < ActiveRecord::Migration[6.0]
  class MiqUserRole < ActiveRecord::Base
    serialize :settings
  end

  def up
    # auth_key_pairs
    say_with_time("Updating MiqUserRole restictions so Auth Key Pairs match existing VMs") do
      MiqUserRole.where(:read_only => false).where("settings LIKE '%vms: :user%'").find_each do |role|
        role.settings[:restrictions][:auth_key_pairs] = role.settings.dig(:restrictions, :vms)
        role.save!
      end
    end
    # orchestration_stacks
    say_with_time("Updating MiqUserRole restictions so Orchestration Stacks match existing VMs") do
      MiqUserRole.where(:read_only => false).where("settings LIKE '%vms: :user%'").find_each do |role|
        role.settings[:restrictions][:orchestration_stacks] = role.settings.dig(:restrictions, :vms)
        role.save!
      end
    end
    # services
    say_with_time("Updating MiqUserRole restictions so Services match existing VMs") do
      MiqUserRole.where(:read_only => false).where("settings LIKE '%vms: :user%'").find_each do |role|
        role.settings[:restrictions][:services] = role.settings.dig(:restrictions, :vms)
        role.save!
      end
    end
  end

  def down
    # auth_key_pairs
    say_with_time("Remove Auth Key Pairs from MiqUserRole restictions") do
      MiqUserRole.where(:read_only => false).where("settings LIKE '%auth_key_pairs:%'").find_each do |role|
        role.settings[:restrictions].delete(:auth_key_pairs)
        if role.settings[:restrictions] == {} && role.settings.length == 1
          role.settings = nil
        end
        role.save!
      end
    end
    # orchestration_stacks
    say_with_time("Remove Orchestration Stacks from MiqUserRole restictions") do
      MiqUserRole.where(:read_only => false).where("settings LIKE '%orchestration_stacks:%'").find_each do |role|
        role.settings[:restrictions].delete(:orchestration_stacks)
        if role.settings[:restrictions] == {} && role.settings.length == 1
          role.settings = nil
        end
        role.save!
      end
    end
    # services
    say_with_time("Remove Services from MiqUserRole restictions") do
      MiqUserRole.where(:read_only => false).where("settings LIKE '%services:%'").find_each do |role|
        role.settings[:restrictions].delete(:services)
        if role.settings[:restrictions] == {} && role.settings.length == 1
          role.settings = nil
        end
        role.save!
      end
    end
  end
end
