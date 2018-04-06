require_migration

describe RemoveProviderRegionForGoogleProvider do
  let(:ems_stub) { migration_stub :ExtManagementSystem }

  migration_context :up do
    before do
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

      migrate
    end

    it 'sets provider_region to nil for ManageIQ::Providers::Google::CloudManager' do
      expect(ems_stub.where(:provider_region => nil).count).to eq 1
    end

    it 'does not set provider_region to nil for other providers' do
      expect(ems_stub.where(:provider_region => 42).count).to eq 4
    end
  end
end
