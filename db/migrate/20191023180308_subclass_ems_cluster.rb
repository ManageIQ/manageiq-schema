class SubclassEmsCluster < ActiveRecord::Migration[5.1]
  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class EmsCluster < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "SubclassEmsCluster::ExtManagementSystem"
  end

  def up
    [
      'Kubevirt',
      'Openstack',
      'Microsoft',
      'Redhat',
      'Vmware',
    ].each do |provider|
      ems_class_name = "ManageIQ::Providers::#{provider}::InfraManager"
      cluster_class_name = "#{ems_class_name}::Cluster"
      EmsCluster.in_my_region.
        joins(:ext_management_system).
        where(:ext_management_systems => {:type => ems_class_name}).
        update_all(:type => cluster_class_name)
    end
  end

  def down
    # Set back ALL the clusters to plain old EmsCluster
    EmsCluster.in_my_region.update_all(:type => nil)

    # OpenStack did subclassing before - so reset these to ManageIQ::Providers::Openstack::InfraManager::EmsCluster
    EmsCluster.in_my_region.
      joins(:ext_management_system).
      where(:ext_management_systems => {:type => 'ManageIQ::Providers::Openstack::InfraManager'}).
      update_all(:type => 'ManageIQ::Providers::Openstack::InfraManager::EmsCluster')
  end
end
