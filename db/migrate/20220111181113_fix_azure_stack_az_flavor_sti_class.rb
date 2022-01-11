class FixAzureStackAzFlavorStiClass < ActiveRecord::Migration[6.0]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class AvailabilityZone < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixAzureStackAzFlavorStiClass::ExtManagementSystem"
  end

  class Flavor < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixAzureStackAzFlavorStiClass::ExtManagementSystem"
  end

  def up
    say_with_time("Fixing AzureStack AZ/Flavor STI class") do
      azure_klass = "ManageIQ::Providers::AzureStack::CloudManager"
      managers = ExtManagementSystem.in_my_region.where(:type => azure_klass)

      AvailabilityZone.in_my_region.where(:ext_management_system => managers).update_all(:type => "#{azure_klass}::AvailabilityZone")
      Flavor.in_my_region.where(:ext_management_system => managers).update_all(:type => "#{azure_klass}::Flavor")
    end
  end

  def down
    say_with_time("Resetting AzureStack AZ/Flavor STI class") do
      azure_klass = "ManageIQ::Providers::AzureStack::CloudManager"
      managers = ExtManagementSystem.in_my_region.where(:type => azure_klass)

      AvailabilityZone.in_my_region.where(:ext_management_system => managers).update_all(:type => nil)
      Flavor.in_my_region.where(:ext_management_system => managers).update_all(:type => nil)
    end
  end
end
