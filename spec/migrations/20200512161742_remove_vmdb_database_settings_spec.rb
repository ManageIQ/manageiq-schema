require_migration

describe RemoveVmdbDatabaseSettings do
  let(:settings_stub) { migration_stub(:SettingsChange) }

  migration_context :up do
    it 'Remove VmdbDatabase Settings' do
      settings_stub.create!(:key => '/database/metrics_collection/collection_schedule', :value => "1 * * * *")
      settings_stub.create!(:key => '/database/metrics_collection/daily_rollup_schedule', :value => "23 0 * * *")
      settings_stub.create!(:key => '/database/metrics_history/keep_daily_metrics', :value => 6.months)
      settings_stub.create!(:key => '/database/metrics_history/keep_hourly_metrics', :value => 6.months)
      settings_stub.create!(:key => '/database/metrics_history/purge_schedule', :value => "50 * * * *")
      settings_stub.create!(:key => '/database/metrics_history/purge_window_size', :value => 10000)
      settings_stub.create!(:key => '/database/metrics_history/queue_timeout', :value => 20.minutes)
      settings_stub.create!(:key => '/ui/display_ops_database', :value => false)
      settings_stub.create!(:key => '/workers/worker_base/schedule_worker/log_database_statistics_interval', :value => 1.days)

      # one setting that should not be touched
      settings_stub.create!(:key => '/ui/mark_translated_strings', :value => true)

      migrate

      expect(settings_stub.count).to eql(1)
      expect(settings_stub.where(:key => '/ui/mark_translated_strings').count).to eql(1)
    end
  end
end


