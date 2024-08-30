class ResetResourcePoolIdentifiers < ActiveRecord::Migration[6.1]
  class MiqProductFeature < ActiveRecord::Base; end

  FEATURE_MAPPING_UPDATE = {
    'resource_pool_infra'           => 'resource_pool',
    'resource_pool_infra_view'      => 'resource_pool_view',
    'resource_pool_infra_show_list' => 'resource_pool_show_list',
    'resource_pool_infra_show'      => 'resource_pool_show',
    'resource_pool_infra_control'   => 'resource_pool_control',
    'resource_pool_infra_tag'       => 'resource_pool_tag',
    'resource_pool_infra_protect'   => 'resource_pool_protect',
    'resource_pool_infra_admin'     => 'resource_pool_admin',
    'resource_pool_infra_delete'    => 'resource_pool_delete'
  }.freeze

  def up
    return if MiqProductFeature.none?

    say_with_time('Resetting resource_pool_infra features back to resource_pool') do
      FEATURE_MAPPING_UPDATE.each do |from, to|
        MiqProductFeature.find_by(:identifier => from)&.update!(:identifier => to)
      end
    end
  end

  def down
    return if MiqProductFeature.none?

    say_with_time('Updating resource_pool features to resource_pool_infra') do
      FEATURE_MAPPING_UPDATE.each do |to, from|
        MiqProductFeature.find_by(:identifier => from)&.update!(:identifier => to)
      end
    end
  end
end
