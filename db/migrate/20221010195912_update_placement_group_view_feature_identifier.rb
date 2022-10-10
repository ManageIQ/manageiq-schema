class UpdatePlacementGroupViewFeatureIdentifier < ActiveRecord::Migration[6.0]
  class MiqProductFeature < ActiveRecord::Base; end

  def up
    say_with_time("Updating Placement Group list feature to view") do
      MiqProductFeature.find_by(:identifier => 'placement_group_list')
                       &.update!(:identifier => 'placement_group_view')
    end
  end

  def down
    say_with_time("Resetting Placement Group view feature back to list") do
      MiqProductFeature.find_by(:identifier => 'placement_group_view')
                       &.update!(:identifier => 'placement_group_list')
    end
  end
end
