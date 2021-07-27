class RenameJobProxyDispatcherSettings < ActiveRecord::Migration[6.0]
  class SettingsChange < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  def up
    schedule_worker_base_key = "/workers/worker_base/schedule_worker"

    %w[
      job_proxy_dispatcher_interval
      job_proxy_dispatcher_stale_message_timeout
      job_proxy_dispatcher_stale_message_check_interval
    ].each do |old_name|
      old_key = "#{schedule_worker_base_key}/#{old_name}"
      new_key = "#{schedule_worker_base_key}/#{old_name.gsub(/^job_proxy/, "vm_scan")}"

      say_with_time("Renaming SettingsChange #{old_key}") do
        SettingsChange.in_my_region.where(:key => old_key).update_all(:key => new_key)
      end
    end
  end

  def down
    schedule_worker_base_key = "/workers/worker_base/schedule_worker"

    %w[
      vm_scan_dispatcher_interval
      vm_scan_dispatcher_stale_message_timeout
      vm_scan_dispatcher_stale_message_check_interval
    ].each do |old_name|
      old_key = "#{schedule_worker_base_key}/#{old_name}"
      new_key = "#{schedule_worker_base_key}/#{old_name.gsub(/^vm_scan/, "job_proxy")}"
      say_with_time("Renaming SettingsChange #{old_key}") do
        SettingsChange.in_my_region.where(:key => old_key).update_all(:key => new_key)
      end
    end
  end
end
