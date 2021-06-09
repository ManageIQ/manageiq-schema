class FixRedhatNetworkManagerStiType < ActiveRecord::Migration[6.0]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class CloudNetwork < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class CloudSubnet < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class FloatingIp < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class NetworkPort < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class NetworkRouter < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class SecurityGroup < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Updating Redhat NetworkManager STI classes") do
      redhat_network_managers = ExtManagementSystem.in_my_region.where(:type => "ManageIQ::Providers::Redhat::NetworkManager").pluck(:id)

      CloudNetwork.in_my_region
                  .where(:ems_id => redhat_network_managers)
                  .where(:type => "ManageIQ::Providers::Openstack::NetworkManager::CloudNetwork")
                  .update_all(:type => "ManageIQ::Providers::Redhat::NetworkManager::CloudNetwork")
      CloudNetwork.in_my_region
                  .where(:ems_id => redhat_network_managers)
                  .where(:type => "ManageIQ::Providers::Openstack::NetworkManager::CloudNetwork::Public")
                  .update_all(:type => "ManageIQ::Providers::Redhat::NetworkManager::CloudNetwork::Public")
      CloudNetwork.in_my_region
                  .where(:ems_id => redhat_network_managers)
                  .where(:type => "ManageIQ::Providers::Openstack::NetworkManager::CloudNetwork::Private")
                  .update_all(:type => "ManageIQ::Providers::Redhat::NetworkManager::CloudNetwork::Private")
      CloudSubnet.in_my_region
                 .where(:ems_id => redhat_network_managers)
                 .where(:type => "ManageIQ::Providers::Openstack::NetworkManager::CloudSubnet")
                 .update_all(:type => "ManageIQ::Providers::Redhat::NetworkManager::CloudSubnet")
      FloatingIp.in_my_region
                .where(:ems_id => redhat_network_managers)
                .where(:type => "ManageIQ::Providers::Openstack::NetworkManager::FloatingIp")
                .update_all(:type => "ManageIQ::Providers::Redhat::NetworkManager::FloatingIp")
      NetworkPort.in_my_region
                 .where(:ems_id => redhat_network_managers)
                 .where(:type => "ManageIQ::Providers::Openstack::NetworkManager::NetworkPort")
                 .update_all(:type => "ManageIQ::Providers::Redhat::NetworkManager::NetworkPort")
      NetworkRouter.in_my_region
                   .where(:ems_id => redhat_network_managers)
                   .where(:type => "ManageIQ::Providers::Openstack::NetworkManager::NetworkRouter")
                   .update_all(:type => "ManageIQ::Providers::Redhat::NetworkManager::NetworkRouter")
      SecurityGroup.in_my_region
                   .where(:ems_id => redhat_network_managers)
                   .where(:type => "ManageIQ::Providers::Openstack::NetworkManager::SecurityGroup")
                   .update_all(:type => "ManageIQ::Providers::Redhat::NetworkManager::SecurityGroup")
    end
  end

  def down
    say_with_time("Updating Redhat NetworkManager STI classes") do
      redhat_network_managers =
        ExtManagementSystem.in_my_region
                           .where(:type => "ManageIQ::Providers::Redhat::NetworkManager").pluck(:id)

      CloudNetwork.in_my_region
                  .where(:ems_id => redhat_network_managers)
                  .where(:type => "ManageIQ::Providers::Redhat::NetworkManager::CloudNetwork")
                  .update_all(:type => "ManageIQ::Providers::Openstack::NetworkManager::CloudNetwork")
      CloudNetwork.in_my_region
                  .where(:ems_id => redhat_network_managers)
                  .where(:type => "ManageIQ::Providers::Redhat::NetworkManager::CloudNetwork::Public")
                  .update_all(:type => "ManageIQ::Providers::Openstack::NetworkManager::CloudNetwork::Public")
      CloudNetwork.in_my_region
                  .where(:ems_id => redhat_network_managers)
                  .where(:type => "ManageIQ::Providers::Redhat::NetworkManager::CloudNetwork::Private")
                  .update_all(:type => "ManageIQ::Providers::Openstack::NetworkManager::CloudNetwork::Private")
      CloudSubnet.in_my_region
                 .where(:ems_id => redhat_network_managers)
                 .where(:type => "ManageIQ::Providers::Redhat::NetworkManager::CloudSubnet")
                 .update_all(:type => "ManageIQ::Providers::Openstack::NetworkManager::CloudSubnet")
      FloatingIp.in_my_region
                .where(:ems_id => redhat_network_managers)
                .where(:type => "ManageIQ::Providers::Redhat::NetworkManager::FloatingIp")
                .update_all(:type => "ManageIQ::Providers::Openstack::NetworkManager::FloatingIp")
      NetworkPort.in_my_region
                 .where(:ems_id => redhat_network_managers)
                 .where(:type => "ManageIQ::Providers::Redhat::NetworkManager::NetworkPort")
                 .update_all(:type => "ManageIQ::Providers::Openstack::NetworkManager::NetworkPort")
      NetworkRouter.in_my_region
                   .where(:ems_id => redhat_network_managers)
                   .where(:type => "ManageIQ::Providers::Redhat::NetworkManager::NetworkRouter")
                   .update_all(:type => "ManageIQ::Providers::Openstack::NetworkManager::NetworkRouter")
      SecurityGroup.in_my_region
                   .where(:ems_id => redhat_network_managers)
                   .where(:type => "ManageIQ::Providers::Redhat::NetworkManager::SecurityGroup")
                   .update_all(:type => "ManageIQ::Providers::Openstack::NetworkManager::SecurityGroup")
    end
  end
end
