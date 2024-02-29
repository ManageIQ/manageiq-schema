require_migration

describe UpdateAuditManagedResourcesQueueName do
  let(:miq_queue_stub) { migration_stub(:MiqQueue) }

  migration_context :up do
    it 'updates audit_managed_resources queued tasks to report_audit_details' do
      audit_managed_resources_task = miq_queue_stub.create!(:state => "ready", :method_name => "audit_managed_resources", :task_id => "audit_managed_resources", :tracking_label => "audit_managed_resources")
      migrate
      audit_managed_resources_task.reload
      expect(audit_managed_resources_task).to have_attributes(:method_name => "report_audit_details", :task_id => "report_audit_details", :tracking_label => "report_audit_details")
    end
  end

  migration_context :down do
    it 'updates report_audit_details queued tasks to audit_managed_resources' do
      report_audit_details_task = miq_queue_stub.create!(:state => "ready", :method_name => "report_audit_details", :task_id => "report_audit_details", :tracking_label => "report_audit_details")
      migrate
      report_audit_details_task.reload
      expect(report_audit_details_task).to have_attributes(:method_name => "audit_managed_resources", :task_id => "audit_managed_resources", :tracking_label => "audit_managed_resources")
    end
  end
end
