class RemoveTransformationProductSetting < ActiveRecord::Migration[5.0]
  class SettingsChange < ActiveRecord::Base
    serialize :value
  end

  def up
    say_with_time("Removing transformation product setting (v2v)") do
      SettingsChange.where(:key => "/product/transformation").delete_all
    end
  end
end
