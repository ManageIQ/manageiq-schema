require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe FixAzureStackAzFlavorStiClass do
  let(:ems_stub)    { migration_stub(:ExtManagementSystem) }
  let(:az_stub)     { migration_stub(:AvailabilityZone) }
  let(:flavor_stub) { migration_stub(:Flavor) }

  migration_context :up do
    it "fixes AzureStack AvailabilityZone and Flavor STI classes" do
      azure_stack = ems_stub.create(:type => "ManageIQ::Providers::AzureStack::CloudManager")

      az     = az_stub.create(:ext_management_system => azure_stack)
      flavor = flavor_stub.create(:ext_management_system => azure_stack)

      migrate

      expect(az.reload.type).to     eq("ManageIQ::Providers::AzureStack::CloudManager::AvailabilityZone")
      expect(flavor.reload.type).to eq("ManageIQ::Providers::AzureStack::CloudManager::Flavor")
    end
  end

  migration_context :down do
    it "resets AzureStack AvailabilityZone and Flavor STI classes" do
      azure_stack = ems_stub.create(:type => "ManageIQ::Providers::AzureStack::CloudManager")

      az     = az_stub.create(:ext_management_system => azure_stack, :type => "ManageIQ::Providers::AzureStack::CloudManager::AvailabilityZone")
      flavor = flavor_stub.create(:ext_management_system => azure_stack, :type => "ManageIQ::Providers::AzureStack::CloudManager::Flavor")

      migrate

      expect(az.reload.type).to     be_nil
      expect(flavor.reload.type).to be_nil
    end
  end
end
