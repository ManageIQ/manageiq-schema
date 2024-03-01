class RemoveKubernetesMonitoringManager < ActiveRecord::Migration[6.1]
  class Endpoint < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class MiqWorker < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class SettingsChange < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  MONITORING_MANAGER_CLASSES = %w[ManageIQ::Providers::Kubernetes::MonitoringManager ManageIQ::Providers::Openshift::MonitoringManager].freeze

  def up
    say_with_time("Removing Kubernetes and OpenShift MonitoringManagers") do
      Endpoint.in_my_region.where(:role => "prometheus_alerts").delete_all
      ExtManagementSystem.in_my_region.where(:type => MONITORING_MANAGER_CLASSES).delete_all
    end

    say_with_time("Removing MonitoringManager EventCatcher MiqWorker records") do
      worker_classes = MONITORING_MANAGER_CLASSES.map { |ems_class| "#{ems_class}::EventCatcher" }

      MiqWorker.in_my_region.where(:type => worker_classes).delete_all
    end

    say_with_time("Removing settings for monitoring managers") do
      SettingsChange.in_my_region.where("key LIKE ?", "/ems/ems_kubernetes/ems_monitoring/%").delete_all
      SettingsChange.in_my_region.where("key LIKE ?", "/workers/worker_base/event_catcher/event_catcher_prometheus/%").delete_all
    end
  end
end
