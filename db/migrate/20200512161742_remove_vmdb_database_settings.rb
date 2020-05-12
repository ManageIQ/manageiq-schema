class RemoveVmdbDatabaseSettings < ActiveRecord::Migration[5.2]
  class SettingsChange < ActiveRecord::Base
  end

  def up
    say_with_time('Removing RemoveVmdbDatabaseSettings') do
      SettingsChange.where(:key => '/database/metrics_collection/collection_schedule').destroy_all
      SettingsChange.where(:key => '/database/metrics_collection/daily_rollup_schedule').destroy_all
      SettingsChange.where(:key => '/database/metrics_history/keep_daily_metrics').destroy_all
      SettingsChange.where(:key => '/database/metrics_history/keep_hourly_metrics').destroy_all
      SettingsChange.where(:key => '/database/metrics_history/purge_schedule').destroy_all
      SettingsChange.where(:key => '/database/metrics_history/purge_window_size').destroy_all
      SettingsChange.where(:key => '/database/metrics_history/queue_timeout').destroy_all
      SettingsChange.where(:key => '/ui/display_ops_database').destroy_all
      SettingsChange.where(:key => '/workers/worker_base/schedule_worker/log_database_statistics_interval').destroy_all
    end
  end
end
