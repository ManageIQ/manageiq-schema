class FixKubevirtHostStorageStiClasses < ActiveRecord::Migration[6.0]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class Host < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixKubevirtHostStorageStiClasses::ExtManagementSystem"
  end

  class Storage < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixKubevirtHostStorageStiClasses::ExtManagementSystem"
  end

  def up
    say_with_time("Fixing Kubevirt STI classes") do
      klass = "ManageIQ::Providers::Kubevirt::InfraManager"

      managers = ExtManagementSystem.in_my_region.where(:type => klass)
      Host.in_my_region.where(:ext_management_system => managers).update_all(:type => "#{klass}::Host")
      Storage.in_my_region.where(:ext_management_system => managers).update_all(:type => "#{klass}::Storage")
    end
  end

  def down
    say_with_time("Resetting Kubevirt STI classes") do
      klass = "ManageIQ::Providers::Kubevirt::InfraManager"

      managers = ExtManagementSystem.in_my_region.where(:type => klass)
      Host.in_my_region.where(:ext_management_system => managers).update_all(:type => nil)
      Storage.in_my_region.where(:ext_management_system => managers).update_all(:type => nil)
    end
  end
end
