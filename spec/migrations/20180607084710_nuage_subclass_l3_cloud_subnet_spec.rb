require_migration

describe NuageSubclassL3CloudSubnet do
  let(:subnet_stub) { migration_stub :CloudSubnet }

  migration_context :up do
    it 'migrates base Nuage type' do
      subnet = subnet_stub.create!(:type => 'ManageIQ::Providers::Nuage::NetworkManager::CloudSubnet')

      migrate
      subnet.reload

      expect(subnet.type).to eql('ManageIQ::Providers::Nuage::NetworkManager::CloudSubnet::L3')
    end

    it 'doesnt modify other subnets' do
      subnet = subnet_stub.create!(:type => 'CloudSubnet')

      migrate
      subnet.reload

      expect(subnet.type).to eql('CloudSubnet')
    end
  end

  migration_context :down do
    it 'restores base Nuage type' do
      subnet_l3 = subnet_stub.create!(:type => 'ManageIQ::Providers::Nuage::NetworkManager::CloudSubnet::L3')
      subnet_l2 = subnet_stub.create!(:type => 'ManageIQ::Providers::Nuage::NetworkManager::CloudSubnet::L2')

      migrate
      subnet_l3.reload
      subnet_l2.reload

      expect(subnet_l3.type).to eql('ManageIQ::Providers::Nuage::NetworkManager::CloudSubnet')
      expect(subnet_l2.type).to eql('ManageIQ::Providers::Nuage::NetworkManager::CloudSubnet')
    end

    it 'doesnt modify other subnets' do
      subnet = subnet_stub.create!(:type => 'CloudSubnet')

      migrate
      subnet.reload

      expect(subnet.type).to eql('CloudSubnet')
    end
  end
end
