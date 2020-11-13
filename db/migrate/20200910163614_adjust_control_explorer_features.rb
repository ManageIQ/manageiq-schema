class AdjustControlExplorerFeatures < ActiveRecord::Migration[5.2]
  class MiqProductFeature < ActiveRecord::Base; end

  FEATURE_MAPPING = {
    'control_explorer'  => 'control'
  }.freeze

  def up
    return if MiqProductFeature.none?

    say_with_time 'Adjusting control_explorer features for the split explorers' do
      # Direct renaming of features
      FEATURE_MAPPING.each do |from, to|
        MiqProductFeature.find_or_create_by!(:identifier => from)&.update!(:identifier => to)
      end
    end
  end

  def down
    say_with_time 'Adjusting split explorer features back to control explorer' do
      FEATURE_MAPPING.each do |to, from|
        MiqProductFeature.find_by(:identifier => from)&.update!(:identifier => to)
      end
    end
  end
end
