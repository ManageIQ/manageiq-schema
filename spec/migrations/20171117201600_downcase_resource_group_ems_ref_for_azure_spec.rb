require_migration

describe DowncaseResourceGroupEmsRefForAzure do
  let(:resource_group_stub) { migration_stub :ResourceGroup }

  let!(:uppercase_stub) do
    resource_group_stub.create!(
      :name    => 'UPPER',
      :ems_ref => '/subscriptions/xyz/resourceGroups/UPPER'
    )
  end

  let!(:mixedcase_stub) do
    resource_group_stub.create!(
      :name    => 'MiXeD',
      :ems_ref => '/subscriptions/xyz/resourceGroups/MiXeD'
    )
  end

  let!(:lowercase_stub) do
    resource_group_stub.create!(
      :name    => 'lower',
      :ems_ref => '/subscriptions/xyz/resourceGroups/lower'
    )
  end

  migration_context :up do
    it 'Downcases the resource group ems_ref column' do
      migrate

      uppercase_stub.reload
      expect(uppercase_stub.ems_ref).to eql('/subscriptions/xyz/resourcegroups/upper')
      expect(uppercase_stub.name).to eql('UPPER')

      mixedcase_stub.reload
      expect(mixedcase_stub.ems_ref).to eql('/subscriptions/xyz/resourcegroups/mixed')
      expect(mixedcase_stub.name).to eql('MiXeD')

      lowercase_stub.reload
      expect(lowercase_stub.ems_ref).to eql('/subscriptions/xyz/resourcegroups/lower')
      expect(lowercase_stub.name).to eql('lower')
    end
  end
end
