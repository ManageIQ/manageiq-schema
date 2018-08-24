class NuageSubclassL3CloudSubnet < ActiveRecord::Migration[5.0]
  class CloudSubnet < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time('Migrating Nuage default subnet type to L3 subnet subclass') do
      CloudSubnet.where(:type => 'ManageIQ::Providers::Nuage::NetworkManager::CloudSubnet')
                 .update_all(:type => 'ManageIQ::Providers::Nuage::NetworkManager::CloudSubnet::L3')
    end
  end

  def down
    say_with_time('Reverting Nuage L3 subnet subclass to default subnet type') do
      CloudSubnet.where(:type => 'ManageIQ::Providers::Nuage::NetworkManager::CloudSubnet::L3')
                 .update_all(:type => 'ManageIQ::Providers::Nuage::NetworkManager::CloudSubnet')
    end

    say_with_time('Reverting Nuage L2 subnet subclass to default subnet type') do
      CloudSubnet.where(:type => 'ManageIQ::Providers::Nuage::NetworkManager::CloudSubnet::L2')
                 .update_all(:type => 'ManageIQ::Providers::Nuage::NetworkManager::CloudSubnet')
    end
  end
end
