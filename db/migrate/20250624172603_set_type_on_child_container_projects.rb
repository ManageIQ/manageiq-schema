class SetTypeOnChildContainerProjects < ActiveRecord::Migration[7.0]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class ContainerProject < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "SetTypeOnChildContainerProjects::ExtManagementSystem"
  end

  PROVIDERS = %w[Amazon Azure Google IbmCloud Kubernetes Openshift OracleCloud Vmware].freeze

  def up
    PROVIDERS.each do |provider|
      provider_klass = "ManageIQ::Providers::#{provider}::ContainerManager"
      say_with_time("Setting STI type for #{provider_klass} ContainerProjects") do
        managers = ExtManagementSystem.in_my_region.where(:type => provider_klass)

        ContainerProject.in_my_region.where(:ext_management_system => managers).update_all(:type => "#{provider_klass}::ContainerProject")
      end
    end
  end

  def down
    PROVIDERS.each do |provider|
      provider_klass = "ManageIQ::Providers::#{provider}::ContainerManager"
      say_with_time("Clearing STI type for #{provider_klass} ContainerProjects") do
        managers = ExtManagementSystem.in_my_region.where(:type => provider_klass)
        ContainerProject.in_my_region.where(:ext_management_system => managers).update_all(:type => nil)
      end
    end
  end
end
