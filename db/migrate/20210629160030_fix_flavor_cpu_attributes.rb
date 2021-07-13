class FixFlavorCpuAttributes < ActiveRecord::Migration[6.0]
  class Flavor < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  # Providers which don't expose the concept of CPU topology (cores/sockets) should have `nil` cpu_cores_per_socket
  # just like Hardware
  FLAVOR_TYPES_NO_SOCKETS = %w[
    ManageIQ::Providers::Amazon::CloudManager::Flavor
    ManageIQ::Providers::Azure::CloudManager::Flavor
    ManageIQ::Providers::DummyProvider::CloudManager::Flavor
    ManageIQ::Providers::IbmCloud::VPC::CloudManager::Flavor
  ].freeze

  def up
    say_with_time("Migrating flavors with no socket information") do
      Flavor.in_my_region.where(:type => FLAVOR_TYPES_NO_SOCKETS).update_all(:cpu_cores_per_socket => nil)
    end

    say_with_time("Migrating Azure Stack flavors") do
      Flavor.in_my_region.where(:type => "ManageIQ::Providers::AzureStack::CloudManager::Flavor").find_each do |flavor|
        # Don't want any ZeroDivisionErrors or NoMethodErrors when taking the inverse
        next if flavor.cpu_cores_per_socket.nil? || flavor.cpu_cores_per_socket.zero?

        # AzureStack parser set the old cpu_cores column to
        # :cpu_cores => flavor.number_of_cores / vcpus_per_socket(flavor.name)
        # which is really the number of sockets
        flavor.cpu_cores_per_socket = flavor.cpu_total_cores / flavor.cpu_cores_per_socket
        flavor.cpu_sockets          = flavor.cpu_cores_per_socket
        flavor.save
      end
    end
  end

  def down
    say_with_time("Migrating flavors with no socket information") do
      Flavor.in_my_region.where(:type => FLAVOR_TYPES_NO_SOCKETS).update_all(:cpu_cores_per_socket => 1)
    end

    say_with_time("Migrating Azure Stack flavors") do
      Flavor.in_my_region.where(:type => "ManageIQ::Providers::AzureStack::CloudManager::Flavor").find_each do |flavor|
        # Don't want any ZeroDivisionErrors or NoMethodErrors when taking the inverse
        next if flavor.cpu_cores_per_socket.nil? || flavor.cpu_cores_per_socket.zero?

        flavor.cpu_cores_per_socket = flavor.cpu_total_cores / flavor.cpu_cores_per_socket
        flavor.save
      end
    end
  end
end
