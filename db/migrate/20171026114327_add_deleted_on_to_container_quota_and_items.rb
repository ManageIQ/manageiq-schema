class AddDeletedOnToContainerQuotaAndItems < ActiveRecord::Migration[5.0]
  class ContainerQuota < ActiveRecord::Base; end
  class ContainerQuotaItem < ActiveRecord::Base; end

  def change
    add_column :container_quotas, :deleted_on, :datetime
    add_index :container_quotas, :deleted_on

    add_timestamps :container_quota_items
    add_column :container_quota_items, :deleted_on, :datetime
    add_index :container_quota_items, :deleted_on
  end
end
