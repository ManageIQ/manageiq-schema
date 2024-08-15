require_migration

RSpec.describe FixVpcFlavorsSti do
  let(:ems_stub)    { migration_stub(:ExtManagementSystem) }
  let(:flavor_stub) { migration_stub(:Flavor) }

  migration_context :up do
    it "fixes VPC flavors' STI class" do
      vpc_manager = ems_stub.create!(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager")
      flavor      = flavor_stub.create!(:ems_id => vpc_manager.id)

      migrate

      expect(flavor.reload.type).to eq("ManageIQ::Providers::IbmCloud::VPC::CloudManager::Flavor")
    end

    it "doesn't impact other flavors" do
      aws_manager = ems_stub.create!(:type => "ManageIQ::Providers::Amazon::CloudManager")
      flavor      = flavor_stub.create!(:type => "ManageIQ::Providers::Amazon::CloudManager::Flavor", :ems_id => aws_manager.id)

      migrate

      expect(flavor.reload.type).to eq("ManageIQ::Providers::Amazon::CloudManager::Flavor")
    end
  end

  migration_context :down do
    it "resets VPC flavors' STI class" do
      vpc_manager = ems_stub.create!(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager")
      flavor      = flavor_stub.create!(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager::Flavor", :ems_id => vpc_manager.id)

      migrate

      expect(flavor.reload.type).to be_nil
    end

    it "doesn't impact other flavors" do
      aws_manager = ems_stub.create!(:type => "ManageIQ::Providers::Amazon::CloudManager")
      flavor      = flavor_stub.create!(:type => "ManageIQ::Providers::Amazon::CloudManager::Flavor", :ems_id => aws_manager.id)

      migrate

      expect(flavor.reload.type).to eq("ManageIQ::Providers::Amazon::CloudManager::Flavor")
    end
  end
end
