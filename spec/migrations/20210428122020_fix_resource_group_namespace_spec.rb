require_migration

RSpec.describe FixResourceGroupNamespace do
  let(:resource_group_stub) { migration_stub(:ResourceGroup) }

  migration_context :up do
    it "Updates the Azure and AzureStack Resource Groups" do
      azure_resource_group       = resource_group_stub.create!(:type => "ManageIQ::Providers::Azure::ResourceGroup")
      azure_stack_resource_group = resource_group_stub.create!(:type => "ManageIQ::Providers::AzureStack::ResourceGroup")

      migrate

      expect(azure_resource_group.reload.type).to       eq("ManageIQ::Providers::Azure::CloudManager::ResourceGroup")
      expect(azure_stack_resource_group.reload.type).to eq("ManageIQ::Providers::AzureStack::CloudManager::ResourceGroup")
    end

    it "Doesn't impact other Resource Groups" do
      resource_group = resource_group_stub.create!(:type => "ManageIQ::Providers::AwesomeCloud::CloudManager::ResourceGroup")

      migrate

      expect(resource_group.reload.type).to eq("ManageIQ::Providers::AwesomeCloud::CloudManager::ResourceGroup")
    end
  end

  migration_context :down do
    it "Updates the Azure and AzureStack Resource Groups" do
      azure_resource_group       = resource_group_stub.create!(:type => "ManageIQ::Providers::Azure::CloudManager::ResourceGroup")
      azure_stack_resource_group = resource_group_stub.create!(:type => "ManageIQ::Providers::AzureStack::CloudManager::ResourceGroup")

      migrate

      expect(azure_resource_group.reload.type).to       eq("ManageIQ::Providers::Azure::ResourceGroup")
      expect(azure_stack_resource_group.reload.type).to eq("ManageIQ::Providers::AzureStack::ResourceGroup")
    end

    it "Doesn't impact other Resource Groups" do
      resource_group = resource_group_stub.create!(:type => "ManageIQ::Providers::AwesomeCloud::CloudManager::ResourceGroup")

      migrate

      expect(resource_group.reload.type).to eq("ManageIQ::Providers::AwesomeCloud::CloudManager::ResourceGroup")
    end
  end
end
