class RenameMessagingTypeSettings < ActiveRecord::Migration[6.0]
  class SettingsChange < ActiveRecord::Base
  end

  def change
    say_with_time("Renaming SettingsChange /prototype/messaging_type") do
      SettingsChange.where(:key => "/prototype/messaging_type").update_all(:key => "/messaging_type", :value => "kafka")
    end
  end
end
