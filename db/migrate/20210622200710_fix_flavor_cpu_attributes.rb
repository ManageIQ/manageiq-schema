class FixFlavorCpuAttributes < ActiveRecord::Migration[6.0]
  class Flavor < ActiveRecord::Base
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
    Flavor.where(:type => FLAVOR_TYPES_NO_SOCKETS).update_all(:cpu_cores_per_socket => nil)
  end

  def down
    Flavor.where(:type => FLAVOR_TYPES_NO_SOCKETS).update_all(:cpu_cores_per_socket => 1)
  end
end
