class MoveLocationLedStateToAssetDetailsTable < ActiveRecord::Migration[5.0]
  class AssetDetail < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  class PhysicalChassis < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
  end

  class PhysicalServer < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
  end

  def up
    add_column :asset_details, :location_led_state, :string

    PhysicalChassis.in_my_region.find_each { |chassis| move_location_led_state_to_asset_detail("PhysicalChassis", chassis) }
    PhysicalServer.in_my_region.find_each { |server| move_location_led_state_to_asset_detail("PhysicalServer", server) }

    remove_column :physical_chassis, :location_led_state
    remove_column :physical_servers, :location_led_state
  end

  def down
    add_column :physical_chassis, :location_led_state, :string
    add_column :physical_servers, :location_led_state, :string

    AssetDetail.where(:resource_type => %w(PhysicalChassis PhysicalServer)).in_my_region.find_each do |asset_detail|
      self.class.const_get(asset_detail.resource_type).update(asset_detail.resource_id, :location_led_state => asset_detail.location_led_state)
    end

    remove_column :asset_details, :location_led_state
  end

  private

  def move_location_led_state_to_asset_detail(class_name, asset)
    AssetDetail.in_my_region.find_or_initialize_by(:resource_type => class_name, :resource_id => asset.id).update_attributes!(:location_led_state => asset.location_led_state)
  end
end
