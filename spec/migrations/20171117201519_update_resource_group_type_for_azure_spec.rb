require_migration

describe UpdateResourceGroupTypeForAzure do
  let(:resource_group_stub) { migration_stub :ResourceGroup }
  let(:expected_type) { 'ManageIQ::Providers::Azure::ResourceGroup' }
  let(:base_type) { 'ResourceGroup' }

  migration_context :up do
    it 'Sets the type column to the expected value' do
      first_group  = resource_group_stub.create!(:name => 'foo', :type => 'Alpha')
      second_group = resource_group_stub.create!(:name => 'bar', :type => 'ResourceGroup')
      third_group  = resource_group_stub.create!(:name => 'baz', :type => 'ManageIQ::Providers::Azure::ResourceGroup')

      migrate

      first_group.reload
      expect(first_group.type).to eql(expected_type)

      second_group.reload
      expect(second_group.type).to eql(expected_type)

      third_group.reload
      expect(third_group.type).to eql(expected_type)
    end
  end

  migration_context :down do
    it 'Sets the type column to the base ResourceGroup type' do
      first_group  = resource_group_stub.create!(:name => 'foo', :type => 'Alpha')
      second_group = resource_group_stub.create!(:name => 'bar', :type => 'ResourceGroup')
      third_group  = resource_group_stub.create!(:name => 'baz', :type => 'ManageIQ::Providers::Azure::ResourceGroup')

      migrate

      first_group.reload
      expect(first_group.type).to eql(base_type)

      second_group.reload
      expect(second_group.type).to eql(base_type)

      third_group.reload
      expect(third_group.type).to eql(base_type)
    end
  end
end
