class RemoveRailsServerFromSettings < ActiveRecord::Migration[5.1]
  class SettingsChange < ActiveRecord::Base
  end

  def up
    say_with_time("Remove rails_server settings") do
      SettingsChange.where(:key => "/server/rails_server").delete_all
    end
  end
end
