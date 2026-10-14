class SetPhysicalServerVendorCisco < ActiveRecord::Migration[8.0]
  class PhysicalServer < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Setting PhysicalServer vendor to cisco for Cisco Intersight records") do
      PhysicalServer.in_my_region
                    .where(:type => "ManageIQ::Providers::CiscoIntersight::PhysicalInfraManager::PhysicalServer")
                    .update_all(:vendor => "cisco")
    end
  end

  def down
    say_with_time("Reverting PhysicalServer vendor to nil for Cisco Intersight records") do
      PhysicalServer.in_my_region
                    .where(:type => "ManageIQ::Providers::CiscoIntersight::PhysicalInfraManager::PhysicalServer")
                    .update_all(:vendor => nil)
    end
  end
end
