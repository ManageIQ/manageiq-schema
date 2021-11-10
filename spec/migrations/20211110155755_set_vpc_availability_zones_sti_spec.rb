require_migration

describe SetVpcAvailabilityZonesSti do
  let(:ems_stub)               { migration_stub(:ExtManagementSystem) }
  let(:availability_zone_stub) { migration_stub(:AvailabilityZone) }

  migration_context :up do
    it "fixes VPC availability zones' STI class" do
      vpc_manager       = ems_stub.create!(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager")
      availability_zone = availability_zone_stub.create!(:ext_management_system => vpc_manager)

      migrate

      expect(availability_zone.reload.type).to eq("ManageIQ::Providers::IbmCloud::VPC::CloudManager::AvailabilityZone")
    end

    it "doesn't impact other availability_zones" do
      aws_manager       = ems_stub.create!(:type => "ManageIQ::Providers::Amazon::CloudManager")
      availability_zone = availability_zone_stub.create!(:type => "ManageIQ::Providers::Amazon::CloudManager::AvailabilityZone", :ext_management_system => aws_manager)

      migrate

      expect(availability_zone.reload.type).to eq("ManageIQ::Providers::Amazon::CloudManager::AvailabilityZone")
    end
  end

  migration_context :down do
    it "resets VPC availability_zones' STI class" do
      vpc_manager       = ems_stub.create!(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager")
      availability_zone = availability_zone_stub.create!(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager::AvailabilityZone", :ext_management_system => vpc_manager)

      migrate

      expect(availability_zone.reload.type).to be_nil
    end

    it "doesn't impact other availability_zones" do
      aws_manager       = ems_stub.create!(:type => "ManageIQ::Providers::Amazon::CloudManager")
      availability_zone = availability_zone_stub.create!(:type => "ManageIQ::Providers::Amazon::CloudManager::AvailabilityZone", :ext_management_system => aws_manager)

      migrate

      expect(availability_zone.reload.type).to eq("ManageIQ::Providers::Amazon::CloudManager::AvailabilityZone")
    end
  end
end
