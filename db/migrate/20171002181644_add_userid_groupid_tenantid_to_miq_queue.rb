class AddUseridGroupidTenantidToMiqQueue < ActiveRecord::Migration[5.0]
  def change
    add_column :miq_queue, :user_id, :bigint
    add_column :miq_queue, :group_id, :bigint
    add_column :miq_queue, :tenant_id, :bigint
  end
end
