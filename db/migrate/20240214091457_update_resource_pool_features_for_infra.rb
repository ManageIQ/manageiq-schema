class UpdateResourcePoolFeaturesForInfra < ActiveRecord::Migration[6.0]
  class MiqProductFeature < ActiveRecord::Base; end

  # Mapping for renaming existing entries to infrastructure
  INFRA_FEATURE_MAPPING = {
    'resource_pool' => 'resource_pool_infra',
    'resource_pool_view' => 'resource_pool_infra_view',
    'resource_pool_show_list' => 'resource_pool_infra_show_list',
    'resource_pool_show' => 'resource_pool_infra_show',
    'resource_pool_control' => 'resource_pool_infra_control',
    'resource_pool_tag' => 'resource_pool_infra_tag',
    'resource_pool_protect' => 'resource_pool_infra_protect',
    'resource_pool_admin' => 'resource_pool_infra_admin',
    'resource_pool_delete' => 'resource_pool_infra_delete'
  }.freeze

  def up
    say_with_time 'Renaming existing features to Infrastructure Resource Pool features' do
      INFRA_FEATURE_MAPPING.each do |from, to|
        feature = MiqProductFeature.find_by(identifier: from)
        feature&.update!(identifier: to)
      end
    end
  end

  def down
    say_with_time 'Reverting Infrastructure Resource Pool features to original features' do
      INFRA_FEATURE_MAPPING.each do |to, from|
        feature = MiqProductFeature.find_by(identifier: from)
        feature&.update!(identifier: to)
      end
    end
  end
end
