class RenameJobProxyDispatcherSettings < ActiveRecord::Migration[6.0]
  class SettingsChange < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

    KEY_SUFFIXES = %w[
    dispatcher_interval
    dispatcher_stale_message_timeout
    dispatcher_stale_message_check_interval
  ].freeze

  def up
    KEY_SUFFIXES.each do |suffix|
      rename_schedule_worker_settings_change("job_proxy_#{suffix}", "vm_scan_#{suffix}")
    end
  end

  def down
    KEY_SUFFIXES.each do |suffix|
      rename_schedule_worker_settings_change("vm_scan_#{suffix}", "job_proxy_#{suffix}")
    end
  end

  private

  def rename_schedule_worker_settings_change(old_name, new_name, base_path = "/workers/worker_base/schedule_worker")
    old_key = "#{base_path}/#{old_name}"
    new_key = "#{base_path}/#{new_name}"

    say_with_time("Renaming SettingsChange #{old_key}") do
      SettingsChange.in_my_region.where(:key => old_key).update_all(:key => new_key)
    end
  end
end
