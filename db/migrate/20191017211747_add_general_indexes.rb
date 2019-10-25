class AddGeneralIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :miq_schedules, :updated_at
    add_index :blacklisted_events, [:ems_id, :enabled]
    add_index :key_pairs_vms, :vm_id
    add_index :miq_requests, [:tenant_id, :approval_state]
    add_index :miq_roles_features, :miq_user_role_id
    add_index :miq_queue, [:state, :handler_type, :handler_id]
    add_index :vms, :tenant_id
    add_index :entitlements, :miq_group_id
    add_index :endpoints, [:resource_id, :resource_type]
  end
end
