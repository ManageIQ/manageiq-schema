class FixIbmPowerHmcHostStiClass < ActiveRecord::Migration[6.0]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class Host < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixIbmPowerHmcHostStiClass::ExtManagementSystem"
  end

  def up
    say_with_time("Fixing IBM Power HMC Host STI class") do
      hmc_klass = "ManageIQ::Providers::IbmPowerHmc::InfraManager"
      managers = ExtManagementSystem.in_my_region.where(:type => hmc_klass)
      Host.in_my_region.where(:ext_management_system => managers).update_all(:type => "#{hmc_klass}::Host")
    end
  end

  def down
    say_with_time("Resetting IBM Power HMC Host STI class") do
      hmc_klass = "ManageIQ::Providers::IbmPowerHmc::InfraManager"
      managers = ExtManagementSystem.in_my_region.where(:type => hmc_klass)
      Host.in_my_region.where(:ext_management_system => managers).update_all(:type => nil)
    end
  end
end
