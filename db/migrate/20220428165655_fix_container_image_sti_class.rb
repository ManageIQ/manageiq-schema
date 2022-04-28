class FixContainerImageStiClass < ActiveRecord::Migration[6.0]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class ContainerImage < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixContainerImageStiClass::ExtManagementSystem"
  end

  def up
    say_with_time("Fixing ContainerImage STI class names") do
      # First update all "Openshift" container images to be ManagedContainerImage types
      ContainerImage.where(:type => "ManageIQ::Providers::Openshift::ContainerManager::ContainerImage")
                    .update_all(:type => "ManageIQ::Providers::Openshift::ContainerManager::ManagedContainerImage")

      # Second update all ::ContainerImage to be subclassed under their provider namespaces
      %w[Amazon Azure Kubernetes Openshift OracleCloud Vmware].each do |provider|
        provider_klass = "ManageIQ::Providers::#{provider}::ContainerManager"

        container_managers = ExtManagementSystem.in_my_region.where(:type => provider_klass)
        ContainerImage.in_my_region
                      .where(:ext_management_system => container_managers, :type => [nil, "ContainerImage"])
                      .update_all(:type => "#{provider_klass}::ContainerImage")
      end
    end
  end

  def down
    %w[Amazon Azure Kubernetes Openshift OracleCloud Vmware].each do |provider|
      provider_klass = "ManageIQ::Providers::#{provider}::ContainerManager"

      container_managers = ExtManagementSystem.in_my_region.where(:type => provider_klass)
      ContainerImage.in_my_region
                    .where(:ext_management_system => container_managers, :type => "#{provider_klass}::ContainerImage")
                    .update_all(:type => nil)
    end

    ContainerImage.where(:type => "ManageIQ::Providers::Openshift::ContainerManager::ManagedContainerImage")
                  .update_all(:type => "ManageIQ::Providers::Openshift::ContainerManager::ContainerImage")
  end
end
