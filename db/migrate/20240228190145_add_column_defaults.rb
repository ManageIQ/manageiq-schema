class AddColumnDefaults < ActiveRecord::Migration[6.1]
  def change
    change_column_default :assigned_server_roles, :active,                   :from => nil, :to => false
    change_column_default :blacklisted_events, :enabled,                     :from => nil, :to => true
    change_column_default :classifications, :read_only,                      :from => nil, :to => false
    change_column_default :classifications, :show,                           :from => nil, :to => true
    change_column_default :classifications, :single_value,                   :from => nil, :to => false
    change_column_default :classifications, :syntax,                         :from => nil, :to => "string"
    change_column_default :cloud_database_flavors, :enabled,                 :from => nil, :to => true  # STI class
    change_column_default :dialog_fields, :load_values_on_init,              :from => nil, :to => true  # STI class, inherited
    change_column_default :dialog_fields, :required,                         :from => nil, :to => false # 
    change_column_default :dialog_fields, :visible,                          :from => nil, :to => true  # STI class, inherited
    change_column_default :dialogs, :system,                                 :from => nil, :to => false
    change_column_default :endpoints, :verify_ssl,                           :from => nil, :to => 1
    change_column_default :ext_management_systems, :enabled,                 :from => nil, :to => true  # STI class, inherited
    change_column_default :flavors, :enabled,                                :from => nil, :to => true  # STI class
    change_column_default :git_repositories, :verify_ssl,                    :from => nil, :to => 1
    change_column_default :miq_approvals, :state,                            :from => nil, :to => "pending"
    change_column_default :miq_groups, :group_type,                          :from => nil, :to => "user"
    change_column_default :miq_policies, :active,                            :from => nil, :to => true
    change_column_default :miq_policies, :mode,                              :from => nil, :to => 'control'
    change_column_default :miq_policies, :towhat,                            :from => nil, :to => 'Vm'
    change_column_default :miq_request_tasks, :state,                        :from => nil, :to => 'pending'
    change_column_default :miq_request_tasks, :status,                       :from => nil, :to => 'Ok'
    change_column_default :miq_requests, :process,                           :from => nil, :to => true
    change_column_default :miq_requests, :request_state,                     :from => nil, :to => 'pending'
    change_column_default :miq_requests, :status,                            :from => nil, :to => 'Ok'
    change_column_default :miq_schedules, :enabled,                          :from => nil, :to => true
    change_column_default :miq_schedules, :userid,                           :from => nil, :to => "system"
    change_column_default :miq_servers, :name,                               :from => nil, :to => "EVM"
    change_column_default :miq_user_roles, :read_only,                       :from => nil, :to => false
    change_column_default :miq_widgets, :enabled,                            :from => nil, :to => true
    change_column_default :miq_widgets, :read_only,                          :from => nil, :to => false
    change_column_default :notification_recipients, :seen,                   :from => nil, :to => false
    change_column_default :orchestration_templates, :draft,                  :from => nil, :to => false
    change_column_default :orchestration_templates, :orderable,              :from => nil, :to => true
    change_column_default :pxe_servers, :customization_directory,            :from => nil, :to => ""
    change_column_default :service_resources, :group_idx,                    :from => nil, :to => 0
    change_column_default :service_resources, :provision_index,              :from => nil, :to => 0
    change_column_default :service_resources, :scaling_max,                  :from => nil, :to => -1
    change_column_default :service_resources, :scaling_min,                  :from => nil, :to => 1
    change_column_default :service_templates, :internal,                     :from => nil, :to => false
    change_column_default :service_templates, :service_type,                 :from => nil, :to => 'atomic'
    change_column_default :services, :initiator,                             :from => nil, :to => 'user'
    change_column_default :services, :lifecycle_state,                       :from => nil, :to => 'unprovisioned'
    change_column_default :services, :retired,                               :from => nil, :to => false
    change_column_default :services, :visible,                               :from => nil, :to => false
    change_column_default :shares, :allow_tenant_inheritance,                :from => nil, :to => false
    change_column_default :system_consoles, :opened,                         :from => nil, :to => false
    change_column_default :tenants, :description,                            :from => nil, :to => "Tenant for My Company"
    change_column_default :tenants, :divisible,                              :from => nil, :to => true
    change_column_default :tenants, :name,                                   :from => nil, :to => "My Company"
    change_column_default :tenants, :use_config_for_attributes,              :from => nil, :to => false
    change_column_default :users, :failed_login_attempts,                    :from => nil, :to => 0
    change_column_default :zones, :visible,                                  :from => nil, :to => true
  end
end
