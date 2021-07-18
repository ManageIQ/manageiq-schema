class UpdateIbmVendorToIbmCloud < ActiveRecord::Migration[6.0]
  class Vm < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time('Updating vendor to "IBM Cloud" for VPC managers') do
      Vm.in_my_region.where(:type => 'ManageIQ::Providers::IbmCloud::VPC::CloudManager::Vm').update_all(:vendor => 'ibm_cloud')
    end
    say_with_time('Updating vendor to "IBM Cloud" for PowerVirtualServer managers') do
      Vm.in_my_region.where(:type => 'ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Vm').update_all(:vendor => 'ibm_cloud')
    end
  end

  def down
    say_with_time('Reverting vendor to "IBM" for VPC managers') do
      Vm.in_my_region.where(:type => 'ManageIQ::Providers::IbmCloud::VPC::CloudManager::Vm').update_all(:vendor => 'ibm')
    end
    say_with_time('Reverting vendor to "IBM" for PowerVirtualServer managers') do
      Vm.in_my_region.where(:type => 'ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Vm').update_all(:vendor => 'ibm')
    end
  end
end
