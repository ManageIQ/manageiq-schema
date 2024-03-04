require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe RemoveKubernetesMonitoringManager do
  let(:endpoint_stub)        { migration_stub(:Endpoint) }
  let(:ems_stub)             { migration_stub(:ExtManagementSystem) }
  let(:miq_worker_stub)      { migration_stub(:MiqWorker) }
  let(:settings_change_stub) { migration_stub(:SettingsChange) }

  migration_context :up do
    it "deletes kubernetes monitoring managers" do
      container_manager = ems_stub.create!(:type => "ManageIQ::Providers::Kubernetes::ContainerManager")
      _alerts_manager   = ems_stub.create!(:type => "ManageIQ::Providers::Kubernetes::MonitoringManager", :parent_ems_id => container_manager.id)
      _default_endpoint = endpoint_stub.create!(:resource_type => "ExtManagementSystem", :resource_id => container_manager.id, :role => "default")
      _alerts_endpoint  = endpoint_stub.create!(:resource_type => "ExtManagementSystem", :resource_id => container_manager.id, :role => "prometheus_alerts")

      migrate

      expect(ems_stub.count).to      eq(1)
      expect(endpoint_stub.count).to eq(1)
    end

    it "deletes openshift monitoring managers" do
      container_manager = ems_stub.create!(:type => "ManageIQ::Providers::Openshift::ContainerManager")
      _alerts_manager   = ems_stub.create!(:type => "ManageIQ::Providers::Openshift::MonitoringManager", :parent_ems_id => container_manager.id)
      _default_endpoint = endpoint_stub.create!(:resource_type => "ExtManagementSystem", :resource_id => container_manager.id, :role => "default")
      _alerts_endpoint  = endpoint_stub.create!(:resource_type => "ExtManagementSystem", :resource_id => container_manager.id, :role => "prometheus_alerts")

      migrate

      expect(ems_stub.count).to      eq(1)
      expect(endpoint_stub.count).to eq(1)
    end

    it "doesn't impact other EMS types" do
      ems_stub.create!(:type => "ManageIQ::Providers::MonitoringManager")
      ems_stub.create!(:type => "ManageIQ::Providers::InfraManager")

      migrate

      expect(ems_stub.count).to eq(2)
    end

    it "deletes kubernetes monitoring manager event_catchers" do
      miq_worker_stub.create!(:type => "ManageIQ::Providers::Kubernetes::MonitoringManager::EventCatcher")

      migrate

      expect(miq_worker_stub.count).to eq(0)
    end

    it "deletes openshift monitoring manager event_catchers" do
      miq_worker_stub.create!(:type => "ManageIQ::Providers::Openshift::MonitoringManager::EventCatcher")

      migrate

      expect(miq_worker_stub.count).to eq(0)
    end

    it "doesn't impact other worker types" do
      miq_worker_stub.create!(:type => "ManageIQ::Providers::InfraManager::EventCatcher")

      migrate

      expect(miq_worker_stub.count).to eq(1)
    end

    it "deletes ems_monitoring settings changes" do
      settings_change_stub.create!(:key => "/ems/ems_kubernetes/ems_monitoring/alerts_collection/open_timeout", :value => "--- 20.seconds\n")
      settings_change_stub.create!(:key => "/workers/worker_base/event_catcher/event_catcher_prometheus/poll", :value => "--- 20.seconds\n")

      migrate

      expect(settings_change_stub.count).to eq(0)
    end
  end
end
