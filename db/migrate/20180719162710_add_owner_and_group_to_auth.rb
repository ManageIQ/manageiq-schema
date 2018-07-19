class AddOwnerAndGroupToAuth < ActiveRecord::Migration[5.0]
  def up
    add_column :authentications, :evm_owner_id, :bigint
    add_column :authentications, :miq_group_id, :bigint
    add_column :authentications, :tenant_id, :bigint
  end

  def down
    remove_column :authentications, :evm_owner_id
    remove_column :authentications, :miq_group_id
    remove_column :authentications, :tenant_id
  end
end
