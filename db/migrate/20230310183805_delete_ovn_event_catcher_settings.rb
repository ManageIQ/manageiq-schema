class DeleteOvnEventCatcherSettings < ActiveRecord::Migration[6.1]
  class SettingsChange < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  def up
    say_with_time("Deleting Ovirt Network Event Catcher SettingsChanges") do
      SettingsChange.in_my_region.where("key LIKE '/workers/worker_base/event_catcher/event_catcher_ovirt_network/%'").delete_all
    end

    say_with_time("Deleting RHV Network Event Catcher SettingsChanges") do
      SettingsChange.in_my_region.where("key LIKE '/workers/worker_base/event_catcher/event_catcher_redhat_network/%'").delete_all
    end
  end
end
