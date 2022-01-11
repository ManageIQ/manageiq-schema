class FixAutosdeStiClass < ActiveRecord::Migration[6.0]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class StorageResource < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixAutosdeStiClass::ExtManagementSystem"
  end

  class StorageService < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixAutosdeStiClass::ExtManagementSystem"
  end

  def up
    say_with_time("Fixing AutoSDE Storage STI classes") do
      autosde_klass = "ManageIQ::Providers::Autosde::StorageManager"
      managers = ExtManagementSystem.in_my_region.where(:type => autosde_klass)

      StorageResource.in_my_region.where(:ext_management_system => managers).update_all(:type => "#{autosde_klass}::StorageResource")
      StorageService.in_my_region.where(:ext_management_system => managers).update_all(:type => "#{autosde_klass}::StorageService")
    end
  end

  def down
    say_with_time("Resetting AutoSDE Storage STI classes") do
      autosde_klass = "ManageIQ::Providers::Autosde::StorageManager"
      managers = ExtManagementSystem.in_my_region.where(:type => autosde_klass)

      StorageResource.in_my_region.where(:ext_management_system => managers).update_all(:type => nil)
      StorageService.in_my_region.where(:ext_management_system => managers).update_all(:type => nil)
    end
  end
end
