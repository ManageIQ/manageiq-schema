class UpdateProductFeaturesWhereIdentifierWasRenamedSinceLasker < ActiveRecord::Migration[6.0]
  class MiqProductFeature < ActiveRecord::Base; end

  FEATURE_MAPPING = {'automation_manager_add_provider' => 'ems_automation_add_provider'}.freeze

  def up
    return if MiqProductFeature.none?

    say_with_time 'Adjusting Automation Provider add provider feature' do
      FEATURE_MAPPING.each do |from, to|
        MiqProductFeature.find_by(:identifier => from)&.update!(:identifier => to)
      end
    end
  end

  def down
    return if MiqProductFeature.none?

    say_with_time 'Adjusting Automation Provider add provider feature' do
      FEATURE_MAPPING.each do |to, from|
        MiqProductFeature.find_by(:identifier => from)&.update!(:identifier => to)
      end
    end
  end
end
