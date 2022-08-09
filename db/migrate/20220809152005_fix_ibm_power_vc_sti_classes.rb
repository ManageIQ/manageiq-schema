class FixIbmPowerVcStiClasses < ActiveRecord::Migration[6.0]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class CloudNetwork < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixIbmPowerVcStiClasses::ExtManagementSystem"
  end

  class CloudSubnet < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixIbmPowerVcStiClasses::ExtManagementSystem"
  end

  class FloatingIp < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixIbmPowerVcStiClasses::ExtManagementSystem"
  end

  class NetworkPort < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixIbmPowerVcStiClasses::ExtManagementSystem"
  end

  class NetworkRouter < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixIbmPowerVcStiClasses::ExtManagementSystem"
  end

  class SecurityGroup < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixIbmPowerVcStiClasses::ExtManagementSystem"
  end

  class CloudVolume < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixIbmPowerVcStiClasses::ExtManagementSystem"
  end

  class CloudVolumeBackup < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixIbmPowerVcStiClasses::ExtManagementSystem"
  end

  class CloudVolumeSnapshot < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixIbmPowerVcStiClasses::ExtManagementSystem"
  end

  class CloudVolumeType < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "FixIbmPowerVcStiClasses::ExtManagementSystem"
  end

  def up
    say_with_time("Fixing IBM PowerVC Network STI classes") do
      ibm_power_vc_network_klass = "ManageIQ::Providers::IbmPowerVc::NetworkManager"
      openstack_network_klass = "ManageIQ::Providers::Openstack::NetworkManager"

      network_managers = ExtManagementSystem.in_my_region.where(:type => ibm_power_vc_network_klass)

      CloudNetwork.in_my_region
                  .where(:ext_management_system => network_managers)
                  .where(:type => "#{openstack_network_klass}::CloudNetwork")
                  .update_all(:type => "#{ibm_power_vc_network_klass}::CloudNetwork")
      CloudNetwork.in_my_region
                  .where(:ext_management_system => network_managers)
                  .where(:type => "#{openstack_network_klass}::CloudNetwork::Public")
                  .update_all(:type => "#{ibm_power_vc_network_klass}::CloudNetwork::Public")
      CloudNetwork.in_my_region
                  .where(:ext_management_system => network_managers)
                  .where(:type => "#{openstack_network_klass}::CloudNetwork::Private")
                  .update_all(:type => "#{ibm_power_vc_network_klass}::CloudNetwork::Private")
      CloudSubnet.in_my_region
                 .where(:ext_management_system => network_managers)
                 .update_all(:type => "#{ibm_power_vc_network_klass}::CloudSubnet")
      FloatingIp.in_my_region
                .where(:ext_management_system => network_managers)
                .update_all(:type => "#{ibm_power_vc_network_klass}::FloatingIp")
      NetworkPort.in_my_region
                 .where(:ext_management_system => network_managers)
                 .update_all(:type => "#{ibm_power_vc_network_klass}::NetworkPort")
      NetworkRouter.in_my_region
                   .where(:ext_management_system => network_managers)
                   .update_all(:type => "#{ibm_power_vc_network_klass}::NetworkRouter")
      SecurityGroup.in_my_region
                   .where(:ext_management_system => network_managers)
                   .update_all(:type => "#{ibm_power_vc_network_klass}::SecurityGroup")
    end

    say_with_time("Fixing IBM PowerVC Storage (Cinder) STI classes") do
      ibm_power_vc_cinder_klass = "ManageIQ::Providers::IbmPowerVc::StorageManager::CinderManager"

      cinder_managers = ExtManagementSystem.in_my_region.where(:type => ibm_power_vc_cinder_klass)

      CloudVolume.in_my_region
                 .where(:ext_management_system => cinder_managers)
                 .update_all(:type => "#{ibm_power_vc_cinder_klass}::CloudVolume")
      CloudVolumeBackup.in_my_region
                       .where(:ext_management_system => cinder_managers)
                       .update_all(:type => "#{ibm_power_vc_cinder_klass}::CloudVolumeBackup")
      CloudVolumeSnapshot.in_my_region
                         .where(:ext_management_system => cinder_managers)
                         .update_all(:type => "#{ibm_power_vc_cinder_klass}::CloudVolumeSnapshot")
      CloudVolumeType.in_my_region
                     .where(:ext_management_system => cinder_managers)
                     .update_all(:type => "#{ibm_power_vc_cinder_klass}::CloudVolumeType")
    end
  end

  def down
    say_with_time("Resetting IBM PowerVC Network STI classes") do
      ibm_power_vc_network_klass = "ManageIQ::Providers::IbmPowerVc::NetworkManager"
      openstack_network_klass = "ManageIQ::Providers::Openstack::NetworkManager"

      network_managers = ExtManagementSystem.in_my_region.where(:type => ibm_power_vc_network_klass)

      CloudNetwork.in_my_region
                  .where(:ext_management_system => network_managers)
                  .where(:type => "#{ibm_power_vc_network_klass}::CloudNetwork")
                  .update_all(:type => "#{openstack_network_klass}::CloudNetwork")
      CloudNetwork.in_my_region
                  .where(:ext_management_system => network_managers)
                  .where(:type => "#{ibm_power_vc_network_klass}::CloudNetwork::Public")
                  .update_all(:type => "#{openstack_network_klass}::CloudNetwork::Public")
      CloudNetwork.in_my_region
                  .where(:ext_management_system => network_managers)
                  .where(:type => "#{ibm_power_vc_network_klass}::CloudNetwork::Private")
                  .update_all(:type => "#{openstack_network_klass}::CloudNetwork::Private")
      CloudSubnet.in_my_region
                 .where(:ext_management_system => network_managers)
                 .update_all(:type => "#{openstack_network_klass}::CloudSubnet")
      FloatingIp.in_my_region
                .where(:ext_management_system => network_managers)
                .update_all(:type => "#{openstack_network_klass}::FloatingIp")
      NetworkPort.in_my_region
                 .where(:ext_management_system => network_managers)
                 .update_all(:type => "#{openstack_network_klass}::NetworkPort")
      NetworkRouter.in_my_region
                   .where(:ext_management_system => network_managers)
                   .update_all(:type => "#{openstack_network_klass}::NetworkRouter")
      SecurityGroup.in_my_region
                   .where(:ext_management_system => network_managers)
                   .update_all(:type => "#{openstack_network_klass}::SecurityGroup")
    end

    say_with_time("Resetting IBM PowerVC Storage (Cinder) STI classes") do
      ibm_power_vc_cinder_klass = "ManageIQ::Providers::IbmPowerVc::StorageManager::CinderManager"
      openstack_cinder_klass = "ManageIQ::Providers::Openstack::StorageManager::CinderManager"

      cinder_managers = ExtManagementSystem.in_my_region.where(:type => ibm_power_vc_cinder_klass)

      CloudVolume.in_my_region
                 .where(:ext_management_system => cinder_managers)
                 .update_all(:type => "#{openstack_cinder_klass}::CloudVolume")
      CloudVolumeBackup.in_my_region
                       .where(:ext_management_system => cinder_managers)
                       .update_all(:type => "#{openstack_cinder_klass}::CloudVolumeBackup")
      CloudVolumeSnapshot.in_my_region
                         .where(:ext_management_system => cinder_managers)
                         .update_all(:type => "#{openstack_cinder_klass}::CloudVolumeSnapshot")
      CloudVolumeType.in_my_region
                     .where(:ext_management_system => cinder_managers)
                     .update_all(:type => "#{openstack_cinder_klass}::CloudVolumeType")
    end
  end
end
