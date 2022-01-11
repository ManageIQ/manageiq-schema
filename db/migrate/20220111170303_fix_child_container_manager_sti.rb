class FixChildContainerManagerSti < ActiveRecord::Migration[6.0]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class ContainerTemplate < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixChildContainerManagerSti::ExtManagementSystem"
  end

  class ServiceInstance < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixChildContainerManagerSti::ExtManagementSystem"
  end

  class ServiceOffering < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixChildContainerManagerSti::ExtManagementSystem"
  end

  class ServiceParametersSet < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixChildContainerManagerSti::ExtManagementSystem"
  end

  PROVIDERS = %w[Amazon Azure Google IbmCloud OracleCloud Vmware].freeze

  def up
    PROVIDERS.each do |provider|
      provider_klass = "ManageIQ::Providers::#{provider}::ContainerManager"
      say_with_time("Fixing STI class for #{provider_klass}") do
        managers = ExtManagementSystem.in_my_region.where(:type => provider_klass)

        ContainerTemplate.in_my_region.where(:ext_management_system => managers).update_all(:type => "#{provider_klass}::ContainerTemplate")
        ServiceInstance.in_my_region.where(:ext_management_system => managers).update_all(:type => "#{provider_klass}::ServiceInstance")
        ServiceOffering.in_my_region.where(:ext_management_system => managers).update_all(:type => "#{provider_klass}::ServiceOffering")
        ServiceParametersSet.in_my_region.where(:ext_management_system => managers).update_all(:type => "#{provider_klass}::ServiceParametersSet")
      end
    end

    def down
      PROVIDERS.each do |provider|
        provider_klass = "ManageIQ::Providers::#{provider}::ContainerManager"
        say_with_time("Resetting STI class for #{provider_klass}") do
          managers = ExtManagementSystem.in_my_region.where(:type => provider_klass)

          ContainerTemplate.in_my_region.where(:ext_management_system => managers).update_all(:type => nil)
          ServiceInstance.in_my_region.where(:ext_management_system => managers).update_all(:type => nil)
          ServiceOffering.in_my_region.where(:ext_management_system => managers).update_all(:type => nil)
          ServiceParametersSet.in_my_region.where(:ext_management_system => managers).update_all(:type => nil)
        end
      end
    end
  end
end
