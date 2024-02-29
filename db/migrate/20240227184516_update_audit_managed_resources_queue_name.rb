class UpdateAuditManagedResourcesQueueName < ActiveRecord::Migration[6.1]
  class MiqQueue < ActiveRecord::Base; end

  def up
    say_with_time("Renaming audit_managed_resources queue items") do
      MiqQueue.where(:method_name => "audit_managed_resources").update_all(:method_name => "report_audit_details", :task_id => "report_audit_details", :tracking_label => "report_audit_details")
    end
  end

  def down
    say_with_time("Renaming report_audit_details queue items") do
      MiqQueue.where(:method_name => "report_audit_details").update_all(:method_name => "audit_managed_resources", :task_id => "audit_managed_resources", :tracking_label => "audit_managed_resources")
    end
  end
end
