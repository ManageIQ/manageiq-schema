require_migration

describe EnsureCloudManagers do
  let(:ems_stub) { migration_stub(:ExtManagementSystem) }
  let(:zone_id)  { anonymous_class_with_id_regions.region_to_range(anonymous_class_with_id_regions.my_region_number).begin }

  let!(:manager) do
    ems_stub.create!(
      :name            => "My Amazon",
      :type            => "ManageIQ::Providers::Amazon::CloudManager",
      :provider_region => "us-east-1",
      :zone_id         => zone_id
    )
  end

  def assert_managers
    emses = ems_stub.order(:type).collect do |ems|
      ems.attributes.slice(*%w[name type provider_region zone_id parent_ems_id])
    end

    expect(emses).to eq(
      [
        {
          "name"            => "My Amazon",
          "type"            => "ManageIQ::Providers::Amazon::CloudManager",
          "provider_region" => "us-east-1",
          "zone_id"         => zone_id,
          "parent_ems_id"   => nil
        },
        {
          "name"            => "My Amazon Network Manager",
          "type"            => "ManageIQ::Providers::Amazon::NetworkManager",
          "provider_region" => "us-east-1",
          "zone_id"         => zone_id,
          "parent_ems_id"   => manager.id
        },
        {
          "name"            => "My Amazon EBS Storage Manager",
          "type"            => "ManageIQ::Providers::Amazon::StorageManager::Ebs",
          "provider_region" => "us-east-1",
          "zone_id"         => zone_id,
          "parent_ems_id"   => manager.id
        },
      ]
    )
  end

  migration_context :up do
    it "creates managers for an Amazon CloudManager without child managers" do
      migrate

      assert_managers
    end

    it "handles an Amazon CloudManager already with child managers" do
      ems_stub.create!(
        :name            => "My Amazon Network Manager",
        :type            => "ManageIQ::Providers::Amazon::NetworkManager",
        :provider_region => "us-east-1",
        :zone_id         => zone_id,
        :parent_ems_id   => manager.id
      )
      ems_stub.create!(
        :name            => "My Amazon EBS Storage Manager",
        :type            => "ManageIQ::Providers::Amazon::StorageManager::Ebs",
        :provider_region => "us-east-1",
        :zone_id         => zone_id,
        :parent_ems_id   => manager.id
      )

      migrate

      assert_managers
    end
  end
end
