require_migration

RSpec.describe FlattenWorkerSettings do
  let(:settings_changes_stub) { migration_stub(:SettingsChange) }

  # These tests cases include at least one setting at every depth, as well as all exceptions
  let(:cases) do
    [
      # Original Unflattened Key                                                                                       New Flattened Key                                                              Value
      ["/workers/worker_base/cockpit_ws_worker/count",                                                                 "/workers/cockpit_ws_worker/count",                                            "--- 1\n"],
      ["/workers/worker_base/defaults/poll",                                                                           "/workers/worker_base/poll",                                                   "--- 3.seconds\n"],
      ["/workers/worker_base/event_catcher/defaults/poll",                                                             "/workers/event_catcher/poll",                                                 "--- 1.seconds\n"],
      ["/workers/worker_base/event_catcher/event_catcher_amazon/poll",                                                 "/workers/event_catcher_amazon/poll",                                          "--- 15.seconds\n"],
      ["/workers/worker_base/event_catcher/event_catcher_openstack_service",                                           "/workers/event_catcher/event_catcher_openstack_service",                      "--- auto\n"],
      ["/workers/worker_base/queue_worker_base/defaults/poll_method",                                                  "/workers/queue_worker_base/poll_method",                                      "--- normal\n"],
      ["/workers/worker_base/queue_worker_base/ems_metrics_collector_worker/defaults/poll_method",                     "/workers/ems_metrics_collector_worker/poll_method",                           "--- escalate\n"],
      ["/workers/worker_base/queue_worker_base/ems_metrics_collector_worker/ems_metrics_collector_worker_amazon/poll", "/workers/ems_metrics_collector_worker_amazon/poll",                           "--- 15.seconds\n"],
      ["/workers/worker_base/queue_worker_base/ems_metrics_collector_worker/ems_metrics_gnocchi_granularity",          "/workers/ems_metrics_collector_worker/ems_metrics_gnocchi_granularity",       "--- 300\n"],
      ["/workers/worker_base/queue_worker_base/ems_metrics_collector_worker/ems_metrics_openstack_default_service",    "/workers/ems_metrics_collector_worker/ems_metrics_openstack_default_service", "--- auto\n"],
      ["/workers/worker_base/queue_worker_base/ems_metrics_processor_worker/count",                                    "/workers/ems_metrics_processor_worker/count",                                 "--- 2\n"],
      ["/workers/worker_base/queue_worker_base/ems_operations_worker/ems_operations_worker_vmware/memory_threshold",   "/workers/ems_operations_worker_vmware/memory_threshold",                      "--- 1.gigabytes\n"],
      ["/workers/worker_base/queue_worker_base/ems_refresh_worker/defaults/poll",                                      "/workers/ems_refresh_worker/poll",                                            "--- 10.seconds\n"],
      ["/workers/worker_base/queue_worker_base/ems_refresh_worker/ems_refresh_worker_amazon/poll",                     "/workers/ems_refresh_worker_amazon/poll",                                     "--- 15.seconds\n"],
      ["/workers/worker_base/queue_worker_base/event_handler/nice_delta",                                              "/workers/event_handler/nice_delta",                                           "--- 7\n"],
      ["/workers/worker_base/queue_worker_base/generic_worker/count",                                                  "/workers/generic_worker/count",                                               "--- 2\n"],
      ["/workers/worker_base/queue_worker_base/priority_worker/count",                                                 "/workers/priority_worker/count",                                              "--- 2\n"],
      ["/workers/worker_base/queue_worker_base/reporting_worker/count",                                                "/workers/reporting_worker/count",                                             "--- 2\n"],
      ["/workers/worker_base/queue_worker_base/smart_proxy_worker/count",                                              "/workers/smart_proxy_worker/count",                                           "--- 2\n"],
      ["/workers/worker_base/remote_console_worker/memory_threshold",                                                  "/workers/remote_console_worker/memory_threshold",                             "--- 1.gigabytes\n"],
      ["/workers/worker_base/schedule_worker/poll",                                                                    "/workers/schedule_worker/poll",                                               "--- 15.seconds\n"],
      ["/workers/worker_base/ui_worker/memory_threshold",                                                              "/workers/ui_worker/memory_threshold",                                         "--- 1.gigabytes\n"],
      ["/workers/worker_base/web_service_worker/memory_threshold",                                                     "/workers/web_service_worker/memory_threshold",                                "--- 1.gigabytes\n"],
    ]
  end

  migration_context :up do
    it "flattens keys" do
      cases.each { |unflattened, _, value| settings_changes_stub.create!(:key => unflattened, :value => value) }

      migrate

      expected = cases.map { |_, flattened, value| [flattened, value] }
      actual   = settings_changes_stub.pluck(:key, :value)
      expect(actual).to match_array(expected)
    end
  end

  migration_context :down do
    it "unflattens keys" do
      cases.each { |_, flattened, value| settings_changes_stub.create!(:key => flattened, :value => value) }

      migrate

      expected = cases.map { |unflattened, _, value| [unflattened, value] }
      actual   = settings_changes_stub.pluck(:key, :value)
      expect(actual).to match_array(expected)
    end
  end
end
