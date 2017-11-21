class AddDeletedOnToContainerQuotaAndItems < ActiveRecord::Migration[5.0]
  class ContainerQuota < ActiveRecord::Base; end
  class ContainerQuotaItem < ActiveRecord::Base
    belongs_to :container_quota, :class_name => "AddDeletedOnToContainerQuotaAndItems::ContainerQuota"
  end

  def change
    add_column :container_quotas, :deleted_on, :datetime
    add_index :container_quotas, :deleted_on

    add_timestamps :container_quota_items, :null => true # temporarily for backfilling, then disallow nulls
    ContainerQuotaItem.reset_column_information

    reversible do |dir|
      dir.up do
        say_with_time("Backfilling container_quota_items timestamps from parent quotas") do
          # All quota items SHOULD have a parent quota, which SHOULD have deleted_on
          # but just in case, fallback to current time.
          now = Time.zone.now
          ContainerQuotaItem.includes(:container_quota).find_each do |item|
            # This also sets updated_at to migration time.
            item.update_attributes!(:created_at => item.container_quota.try(:created_on) || now)
          end
        end
      end
      # down: unnecessary, created_at/updated_at columns get deleted.
    end

    change_column_null :container_quota_items, :created_at, false
    change_column_null :container_quota_items, :updated_at, false

    add_column :container_quota_items, :deleted_on, :datetime
    add_index :container_quota_items, :deleted_on
  end
end
