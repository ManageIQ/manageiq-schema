require_migration

RSpec.describe FixFlavorCpuAttributes do
  let(:flavor_stub) { migration_stub(:Flavor) }

  migration_context :up do
    it "migrates flavors that have no sockets" do
      amazon_flavor = flavor_stub.create!(:type => "ManageIQ::Providers::Amazon::CloudManager::Flavor", :cpu_total_cores => 2, :cpu_cores_per_socket => 1)
      azure_flavor  = flavor_stub.create!(:type => "ManageIQ::Providers::Azure::CloudManager::Flavor", :cpu_total_cores => 2, :cpu_cores_per_socket => 1)
      dummy_flavor  = flavor_stub.create!(:type => "ManageIQ::Providers::DummyProvider::CloudManager::Flavor", :cpu_total_cores => 2, :cpu_cores_per_socket => 1)
      vpc_flavor    = flavor_stub.create!(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager::Flavor", :cpu_total_cores => 2, :cpu_cores_per_socket => 1)

      migrate

      expect(amazon_flavor.reload).to have_attributes(
        :cpu_total_cores      => 2,
        :cpu_cores_per_socket => nil
      )
      expect(azure_flavor.reload).to have_attributes(
        :cpu_total_cores      => 2,
        :cpu_cores_per_socket => nil
      )
      expect(dummy_flavor.reload).to have_attributes(
        :cpu_total_cores      => 2,
        :cpu_cores_per_socket => nil
      )
      expect(vpc_flavor.reload).to have_attributes(
        :cpu_total_cores      => 2,
        :cpu_cores_per_socket => nil
      )
    end

    it "migrates azure_stack with incorrect cpu_cores_per_socket value" do
      expected_cpu_total_cores = 4
      expected_cpu_cores_per_socket = 2
      expected_cpu_sockets = 2

      azure_stack_flavor = flavor_stub.create!(
        :type                 => "ManageIQ::Providers::AzureStack::CloudManager::Flavor",
        :cpu_total_cores      => expected_cpu_total_cores,
        :cpu_cores_per_socket => expected_cpu_total_cores / expected_cpu_cores_per_socket
      )

      migrate

      expect(azure_stack_flavor.reload).to have_attributes(
        :cpu_total_cores      => expected_cpu_total_cores,
        :cpu_cores_per_socket => expected_cpu_cores_per_socket,
        :cpu_sockets          => expected_cpu_sockets
      )
    end

    it "doesn't fail with nil cpu_cores_per_socket on azure_stack flavors" do
      expected_cpu_total_cores = 4

      azure_stack_flavor = flavor_stub.create!(
        :type                 => "ManageIQ::Providers::AzureStack::CloudManager::Flavor",
        :cpu_total_cores      => expected_cpu_total_cores,
        :cpu_cores_per_socket => nil
      )

      migrate

      expect(azure_stack_flavor.reload).to have_attributes(
        :cpu_total_cores      => expected_cpu_total_cores,
        :cpu_cores_per_socket => nil,
        :cpu_sockets          => 1
      )
    end

    it "doesn't migrate other provider's flavors" do
      flavor = flavor_stub.create!(
        :type                 => "ManageIQ::Providers::OracleCloud::CloudManager::Flavor",
        :cpu_total_cores      => 4,
        :cpu_cores_per_socket => 2,
        :cpu_sockets          => 2
      )

      migrate

      expect(flavor.reload).to have_attributes(
        :cpu_total_cores      => 4,
        :cpu_cores_per_socket => 2,
        :cpu_sockets          => 2
      )
    end
  end

  migration_context :down do
    it "resets cores_per_socket for flavors that have no sockets" do
      amazon_flavor = flavor_stub.create!(:type => "ManageIQ::Providers::Amazon::CloudManager::Flavor", :cpu_total_cores => 2, :cpu_cores_per_socket => nil)
      azure_flavor  = flavor_stub.create!(:type => "ManageIQ::Providers::Azure::CloudManager::Flavor", :cpu_total_cores => 2, :cpu_cores_per_socket => nil)
      dummy_flavor  = flavor_stub.create!(:type => "ManageIQ::Providers::DummyProvider::CloudManager::Flavor", :cpu_total_cores => 2, :cpu_cores_per_socket => nil)
      vpc_flavor    = flavor_stub.create!(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager::Flavor", :cpu_total_cores => 2, :cpu_cores_per_socket => nil)

      migrate

      expect(amazon_flavor.reload).to have_attributes(
        :cpu_total_cores      => 2,
        :cpu_cores_per_socket => 1
      )
      expect(azure_flavor.reload).to have_attributes(
        :cpu_total_cores      => 2,
        :cpu_cores_per_socket => 1
      )
      expect(dummy_flavor.reload).to have_attributes(
        :cpu_total_cores      => 2,
        :cpu_cores_per_socket => 1
      )
      expect(vpc_flavor.reload).to have_attributes(
        :cpu_total_cores      => 2,
        :cpu_cores_per_socket => 1
      )
    end

    it "doesn't migrate other provider's flavors" do
      flavor = flavor_stub.create!(
        :type                 => "ManageIQ::Providers::OracleCloud::CloudManager::Flavor",
        :cpu_total_cores      => 4,
        :cpu_cores_per_socket => 2,
        :cpu_sockets          => 2
      )

      migrate

      expect(flavor.reload).to have_attributes(
        :cpu_total_cores      => 4,
        :cpu_cores_per_socket => 2,
        :cpu_sockets          => 2
      )
    end
  end
end
