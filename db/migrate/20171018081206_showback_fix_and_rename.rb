class ShowbackFixAndRename < ActiveRecord::Migration[5.0]
  def change
    rename_table :showback_events,      :showback_data_rollups
    rename_table :showback_charges,     :showback_data_views
    rename_table :showback_pools,       :showback_envelopes
    rename_table :showback_usage_types, :showback_input_measures

    rename_column :showback_data_views, :showback_event_id,      :showback_data_rollup_id
    rename_column :showback_data_views, :showback_pool_id,       :showback_envelope_id

    rename_column :showback_rates,      :category,      :entity
    rename_column :showback_rates,      :dimension,     :field
    rename_column :showback_rates,      :measure,       :group
    rename_column :showback_rates,      :step_variable, :tier_input_variable
    rename_column :showback_rates,      :date,          :start_date

    rename_column :showback_input_measures, :category,   :entity
    rename_column :showback_input_measures, :dimensions, :fields
    rename_column :showback_input_measures, :measure,    :group

    rename_column :showback_data_views, :stored_data, :data_snapshot

    add_column :showback_data_views, :context_snapshot, :jsonb
    add_column :showback_data_views, :start_time,       :timestamp
    add_column :showback_data_views, :end_time,         :timestamp
  end
end
