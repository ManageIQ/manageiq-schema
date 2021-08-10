class RemoveUpdateRepoNamesFromSettings < ActiveRecord::Migration[6.0]
  class SettingsChange < ActiveRecord::Base
  end

  def up
    say_with_time("deleting update_repo_names that are no longer used") do
      SettingsChange.where(:resource_type => "MiqRegion", :key => "/product/update_repo_names")
                    .destroy_all
    end
  end
end
