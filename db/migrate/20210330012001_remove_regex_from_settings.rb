class RemoveRegexFromSettings < ActiveRecord::Migration[6.0]
  class SettingsChange < ActiveRecord::Base
    serialize :value
  end

  def up
    say_with_time("Changing regexps in configurations") do
      SettingsChange.where("value LIKE ?", "%!ruby/regexp%")
                    .update_all("value = REGEXP_REPLACE(value, '!ruby/regexp ','','g')")
    end
  end
end
