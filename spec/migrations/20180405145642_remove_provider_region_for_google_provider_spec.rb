require_migration

describe RemoveProviderRegionForGoogleProvider do
  migration_context :up do
    let(:ems_stub) { migration_stub :ExtManagementSystem }

    it 'does sets provider_region to nil only to Google provider' do
      ems_stub.create!(:type            => 'ManageIQ::Providers::Google::CloudManager',
                       :provider_region => 42)
      ems_stub.create!(:type            => 'ManageIQ::Providers::Amazon::CloudManager',
                       :provider_region => 42)
      ems_stub.create!(:type            => 'ManageIQ::Providers::Azure::CloudManager',
                       :provider_region => 42)
      ems_stub.create!(:type            => 'ManageIQ::Providers::Openstack::CloudManager',
                       :provider_region => 42)
      ems_stub.create!(:type            => 'ManageIQ::Providers::Vmware::CloudManager',
                       :provider_region => 42)
      ems_stub.create!(:type            => 'ManageIQ::Providers::Google::NetworkManager',
                       :provider_region => 42)
      ems_stub.create!(:type            => 'ManageIQ::Providers::Openstack::NetworkManager',
                       :provider_region => 42)
      ems_stub.create!(:type            => 'ManageIQ::Providers::Azure::NetworkManager',
                       :provider_region => 42)
      ems_stub.create!(:type            => 'ManageIQ::Providers::Amazon::NetworkManager',
                       :provider_region => 42)
      ems_stub.create!(:type            => 'ManageIQ::Providers::Vmware::NetworkManager',
                       :provider_region => 42)

      migrate

      expect(ems_stub.where(:provider_region => nil).count).to eq 2
      expect(ems_stub.where(:provider_region => 42).count).to eq 8
    end
  end
end
