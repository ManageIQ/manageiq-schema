class IssueShowbackTiers < ActiveRecord::Migration[5.0]
  def up
    rename_column    :showback_tiers, :showback_rates_id, :showback_rate_id
    change_column    :showback_tiers, :tier_start_value,  :float
    change_column    :showback_tiers, :tier_end_value,    :float
  end

  def down
    rename_column    :showback_tiers, :showback_rate_id,   :showback_rates_id
    change_column    :showback_tiers, :tier_start_value, :bigint
    change_column    :showback_tiers, :tier_end_value,   :bigint
  end
end
