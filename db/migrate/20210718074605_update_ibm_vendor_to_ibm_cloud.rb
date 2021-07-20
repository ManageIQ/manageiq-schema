class UpdateIbmVendorToIbmCloud < ActiveRecord::Migration[6.0]
  class VmOrTemplate < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
    self.table_name = 'vms'
  end

  def up
    say_with_time('Updating vendor to "IBM Cloud" for VPC managers') do
      VmOrTemplate.in_my_region.where(:type => %w[ManageIQ::Providers::IbmCloud::VPC::CloudManager::Vm ManageIQ::Providers::IbmCloud::VPC::CloudManager::Template]).update_all(:vendor => 'ibm_cloud')
    end
    say_with_time('Updating vendor to "IBM Cloud" for PowerVirtualServer managers') do
      VmOrTemplate.in_my_region.where(:type => %w[ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Vm ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Template]).update_all(:vendor => 'ibm_cloud')
    end
  end

  def down
    say_with_time('Reverting vendor to "IBM" for VPC managers') do
      VmOrTemplate.in_my_region.where(:type => %w[ManageIQ::Providers::IbmCloud::VPC::CloudManager::Vm ManageIQ::Providers::IbmCloud::VPC::CloudManager::Template]).update_all(:vendor => 'ibm')
    end
    say_with_time('Reverting vendor to "IBM" for PowerVirtualServer managers') do
      VmOrTemplate.in_my_region.where(:type => %w[ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Vm ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Template]).update_all(:vendor => 'ibm')
    end
  end
end
