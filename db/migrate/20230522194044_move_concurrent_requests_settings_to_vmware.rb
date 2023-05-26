class MoveConcurrentRequestsSettingsToVmware < ActiveRecord::Migration[6.1]
  class SettingsChange < ActiveRecord::Base
  end

  def up
    # global concurrent_requests
    #   only currently read by vmware
    #
    # rename "/performance/concurrent_requests/{realtime,historical,}" =>
    #        "/ems/ems_vmware/concurrent_requests/*"
    say_with_time("Moving global concurrent requests to provider") do
      SettingsChange.where("key LIKE ?", "/performance/concurrent_requests/%")
                    .update_all("key = REPLACE(key, '/performance/concurrent_requests/', '/ems/ems_vmware/concurrent_requests/')")
    end
  end

  def down
    # rename "/ems/ems_vmware/concurrent_requests/*" =>
    #        "/performance/concurrent_requests/{realtime,historical,}"
    say_with_time("Moving provider concurrent requests to global") do
      SettingsChange.where("key LIKE ?", "/ems/ems_vmware/concurrent_requests/%")
                    .update_all("key = REPLACE(key, '/ems/ems_vmware/concurrent_requests/', '/performance/concurrent_requests/')")
    end
  end
end
