class RenameJobProxyDispatcherSettings < ActiveRecord::Migration[6.0]
  class SettingsChange < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  def up
    %w[
      job_proxy_dispatcher_interval
      job_proxy_dispatcher_stale_message_timeout
      job_proxy_dispatcher_stale_message_check_interval
    ].each do |old_name|
      rename_schedule_worker_settings_change(old_name, old_name.gsub(/^job_proxy/, "vm_scan"))
    end
  end

  def down
    %w[
      vm_scan_dispatcher_interval
      vm_scan_dispatcher_stale_message_timeout
      vm_scan_dispatcher_stale_message_check_interval
    ].each do |old_name|
      rename_schedule_worker_settings_change(old_name, old_name.gsub(/^vm_scan/, "job_proxy"))
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
