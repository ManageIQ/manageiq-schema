class FixVcloudNetworkStiClasses < ActiveRecord::Migration[6.0]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class LoadBalancer < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixVcloudNetworkStiClasses::ExtManagementSystem"
  end

  class LoadBalancerHealthCheck < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixVcloudNetworkStiClasses::ExtManagementSystem"
  end

  class LoadBalancerListener < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixVcloudNetworkStiClasses::ExtManagementSystem"
  end

  class LoadBalancerPool < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixVcloudNetworkStiClasses::ExtManagementSystem"
  end

  class LoadBalancerPoolMember < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixVcloudNetworkStiClasses::ExtManagementSystem"
  end

  class SecurityGroup < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixVcloudNetworkStiClasses::ExtManagementSystem"
  end

  def up
    say_with_time("Fixing vCloud Network STI classes") do
      vcloud_network_klass = "ManageIQ::Providers::Vmware::NetworkManager"
      managers = ExtManagementSystem.in_my_region.where(:type => vcloud_network_klass)

      [LoadBalancer, LoadBalancerListener, LoadBalancerPool, LoadBalancerPoolMember, LoadBalancerHealthCheck, SecurityGroup].each do |klass|
        klass_name = klass.name.split("::").last # We want e.g. LoadBalancer from FixVcloudNetworkStiClasses::LoadBalancer
        klass.in_my_region.where(:ext_management_system => managers).update_all(:type => "#{vcloud_network_klass}::#{klass_name}")
      end
    end
  end

  def down
    say_with_time("Resetting vCloud Network STI classes") do
      vcloud_network_klass = "ManageIQ::Providers::Vmware::NetworkManager"
      managers = ExtManagementSystem.in_my_region.where(:type => vcloud_network_klass)

      [LoadBalancer, LoadBalancerListener, LoadBalancerPool, LoadBalancerPoolMember, LoadBalancerHealthCheck, SecurityGroup].each do |klass|
        klass.in_my_region.where(:ext_management_system => managers).update_all(:type => nil)
      end
    end
  end
end
