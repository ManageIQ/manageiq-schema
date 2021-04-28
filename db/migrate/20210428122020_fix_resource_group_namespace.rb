class FixResourceGroupNamespace < ActiveRecord::Migration[6.0]
  class ResourceGroup < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  def up
    ResourceGroup.in_my_region
                 .where(:type => "ManageIQ::Providers::Azure::ResourceGroup")
                 .update_all(:type => "ManageIQ::Providers::Azure::CloudManager::ResourceGroup")
    ResourceGroup.in_my_region
                 .where(:type => "ManageIQ::Providers::AzureStack::ResourceGroup")
                 .update_all(:type => "ManageIQ::Providers::AzureStack::CloudManager::ResourceGroup")
  end

  def down
    ResourceGroup.in_my_region
                 .where(:type => "ManageIQ::Providers::Azure::CloudManager::ResourceGroup")
                 .update_all(:type => "ManageIQ::Providers::Azure::ResourceGroup")
    ResourceGroup.in_my_region
                 .where(:type => "ManageIQ::Providers::AzureStack::CloudManager::ResourceGroup")
                 .update_all(:type => "ManageIQ::Providers::AzureStack::ResourceGroup")
  end
end
