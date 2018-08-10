class AzureBackslashToForwardSlash < ActiveRecord::Migration[5.0]
  class Vm < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class OrchestrationStack < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class OrchestrationStackOutput < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class OrchestrationStackParameter < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class OrchestrationStackResource < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class EventStream < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Updating Azure VM ems_ref, uid_ems and description") do
      Vm.where(:type => "ManageIQ::Providers::Azure::CloudManager::Vm")
        .update_all("
          ems_ref = replace(ems_ref, '\\', '/'),
          uid_ems = replace(uid_ems, '\\', '/'),
          description = replace(description, '\\', '/')
        ")
    end

    say_with_time("Updating Azure template ems_ref, uid_ems and description") do
      Vm.where(:type => "ManageIQ::Providers::Azure::CloudManager::Template")
        .update_all("
          ems_ref = replace(ems_ref, '\\', '/'),
          uid_ems = replace(uid_ems, '\\', '/'),
          description = replace(description, '\\', '/')
        ")
    end

    say_with_time("Updating Azure orchestration stack ems_ref") do
      OrchestrationStack
        .where(:type => "ManageIQ::Providers::Azure::CloudManager::OrchestrationStack")
        .update_all("ems_ref = replace(ems_ref, '\\', '/'), description = replace(description, '\\', '/')")
    end

    say_with_time("Updating Azure orchestration stack output ems_ref") do
      OrchestrationStackOutput
        .where(:stack_id => OrchestrationStack.where(:type => "ManageIQ::Providers::Azure::CloudManager::OrchestrationStack"))
        .update_all("ems_ref = replace(ems_ref, '\\', '/')")
    end

    say_with_time("Updating Azure orchestration stack parameter ems_ref") do
      OrchestrationStackParameter
        .where(:stack_id => OrchestrationStack.where(:type => "ManageIQ::Providers::Azure::CloudManager::OrchestrationStack"))
        .update_all("ems_ref = replace(ems_ref, '\\', '/')")
    end

    say_with_time("Updating Azure orchestration stack resource ems_ref") do
      OrchestrationStackResource
        .where(:stack_id => OrchestrationStack.where(:type => "ManageIQ::Providers::Azure::CloudManager::OrchestrationStack"))
        .update_all("ems_ref = replace(ems_ref, '\\', '/'), description = replace(description, '\\', '/')")
    end

    say_with_time("Updating Azure event stream ems_ref") do
      EventStream.where(:source => "AZURE").where.not(:vm_ems_ref => nil).update_all("vm_ems_ref = replace(vm_ems_ref, '\\', '/')")
    end
  end
end
