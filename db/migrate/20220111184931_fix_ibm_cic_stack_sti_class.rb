class FixIbmCicStackStiClass < ActiveRecord::Migration[6.0]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class OrchestrationStack < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixIbmCicStackStiClass::ExtManagementSystem"
  end

  def up
    say_with_time("Fixing IBM CIC OrchestrationStack STI class") do
      klass = "ManageIQ::Providers::IbmCic::CloudManager"

      managers = ExtManagementSystem.in_my_region.where(:type => klass)
      OrchestrationStack.in_my_region.where(:ext_management_system => managers).update_all(:type => "#{klass}::OrchestrationStack")
    end
  end

  def down
    say_with_time("Resetting IBM CIC OrchestrationStack STI class") do
      klass = "ManageIQ::Providers::IbmCic::CloudManager"

      managers = ExtManagementSystem.in_my_region.where(:type => klass)
      OrchestrationStack.in_my_region.where(:ext_management_system => managers).update_all(:type => nil)
    end
  end
end
