require_migration

describe RemoveMigrationFeature do
  migration_context :up do
    let(:service_template) { migration_stub(:ServiceTemplate) }
    let(:miq_request) { migration_stub(:MiqRequest) }
    let(:miq_request_task) { migration_stub(:MiqRequestTask) }
    let(:job) { migration_stub(:Job) }
    let(:service_order) { migration_stub(:ServiceOrder) }
    let(:conversion_host) { migration_stub(:ConversionHost) }
    let(:tag) { migration_stub(:Tag) }
    let(:tagging) { migration_stub(:Tagging) }
    let(:custom_attribute) { migration_stub(:CustomAttribute) }
    let(:vm) { migration_stub(:Vm) }
    let(:host) { migration_stub(:Host) }
    let(:notification) { migration_stub(:Notification) }
    let(:notification_type) { migration_stub(:NotificationType) }
    let(:authentication) { migration_stub(:Authentication) }
    let(:settings_change) { migration_stub(:SettingsChange) }

    it "cleans the database and removes the tables" do
      service_template.create!(:type => "ServiceTemplate")
      service_template.create!(:type => "ServiceTemplateTransformationPlan")
      service_template.create!(:type => "ManageIQ::Providers::Openstack::CloudManager::ServiceTemplateTransformationPlan")
      service_template.create!(:type => "ManageIQ::Providers::Redhat::InfraManager::ServiceTemplateTransformationPlan")

      miq_request.create!(:type => "MiqRequest")
      miq_request.create!(:type => "ServiceTemplateTransformationPlanRequest")

      miq_request_task.create!(:type => "MiqRequestTask")
      miq_request_task.create!(:type => "ServiceTemplateTransformationPlanTask")

      job.create!(:type => "Job")
      job.create!(:type => "InfraConversionJob")

      service_order.create!(:type => "ServiceOrder")
      service_order.create!(:type => "ServiceOrderV2V")

      tag_1 = tag.create!(:name => "/managed/v2v_transformation_host/false")
      tag_2 = tag.create!(:name => "/managed/v2v_transformation_host/true")
      tag_3 = tag.create!(:name => "/managed/v2v_transformation_method/vddk")
      tag_4 = tag.create!(:name => "/managed/v2v_transformation_method/ssh")
      tag_5 = tag.create!(:name => "/managed/stub/dummy")

      tagging.create!(:tag_id => tag_1.id)
      tagging.create!(:tag_id => tag_2.id)
      tagging.create!(:tag_id => tag_3.id)
      tagging.create!(:tag_id => tag_4.id)
      tagging.create!(:tag_id => tag_5.id)

      vm_1 = vm.create!(:type => "Vm")
      custom_attribute.create!(:resource_id => vm_1.id, :resource_type => "Vm", :name => "TransformationIPAddress", :value => "10.0.0.1")
      custom_attribute.create!(:resource_id => vm_1.id, :resource_type => "Vm", :name => "stub", :value => "dummy")
      conversion_host.create!(:resource_id => vm_1.id, :resource_type => "Vm")

      nt_1 = notification_type.create!(:name => "transformation_plan_request_succeeded")
      nt_2 = notification_type.create!(:name => "transformation_plan_request_failed")
      nt_3 = notification_type.create!(:name => "conversion_host_config_success")
      nt_4 = notification_type.create!(:name => "conversion_host_config_failure")
      nt_5 = notification_type.create!(:name => "other")

      notification.create!(:notification_type_id => nt_1.id)
      notification.create!(:notification_type_id => nt_2.id)
      notification.create!(:notification_type_id => nt_3.id)
      notification.create!(:notification_type_id => nt_4.id)
      notification.create!(:notification_type_id => nt_5.id)

      authentication.create!(:authtype => "v2v")
      authentication.create!(:authtype => "other")

      settings_change.create!(:key => "/server/company", :value => "other")
      settings_change.create!(:key => "/transformation/job/retry_interval", :value => 20)
      settings_change.create!(:key => "/transformation/limits/max_concurrent_tasks_per_ems", :value => 20)
      settings_change.create!(:key => "/workers/worker_base/schedule_worker/infra_conversion_dispatcher_interval", :value => 60.seconds)

      migrate

      expect(service_template.count).to eq(1)
      expect(service_template.first.type).to eq("ServiceTemplate")

      expect(miq_request.count).to eq(1)
      expect(miq_request.first.type).to eq("MiqRequest")

      expect(miq_request_task.count).to eq(1)
      expect(miq_request_task.first.type).to eq("MiqRequestTask")

      expect(job.count).to eq(1)
      expect(job.first.type).to eq("Job")

      expect(service_order.count).to eq(1)
      expect(service_order.first.type).to eq("ServiceOrder")

      expect(tag.count).to eq(1)
      expect(tag.first.name).to eq("/managed/stub/dummy")

      expect(tagging.count).to eq(1)
      expect(tagging.first.tag_id).to eq(tag_5.id)

      expect(custom_attribute.count).to eq(1)
      expect(custom_attribute.first.name).to eq("stub")
      expect(custom_attribute.first.value).to eq("dummy")

      expect(notification_type.count).to eq(1)
      expect(notification_type.first.name).to eq("other")
      expect(notification.count).to eq(1)
      expect(notification.first.notification_type_id).to eq(nt_5.id)

      expect(authentication.count).to eq(1)
      expect(authentication.first.authtype).to eq("other")

      expect(settings_change.count).to eq(1)
      expect(settings_change.first.key).to eq("/server/company")
      expect(settings_change.first.value).to eq("other")
    end
  end
end
