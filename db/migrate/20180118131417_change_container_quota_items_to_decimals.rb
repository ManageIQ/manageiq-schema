class ChangeContainerQuotaItemsToDecimals < ActiveRecord::Migration[5.0]
  def up
    %i(quota_desired quota_enforced quota_observed).each do |column|
      change_column :container_quota_items, column, :decimal, :scale => 3, :precision => 30
    end
  end

  def down
    %i(quota_desired quota_enforced quota_observed).each do |column|
      change_column :container_quota_items, column, :float
    end
  end
end
