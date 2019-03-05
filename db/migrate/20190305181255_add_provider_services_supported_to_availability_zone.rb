class AddProviderServicesSupportedToAvailabilityZone < ActiveRecord::Migration[5.0]
  def change
    add_column :availability_zones, :provider_services_supported, :string, :array => true, :default => []
  end
end
