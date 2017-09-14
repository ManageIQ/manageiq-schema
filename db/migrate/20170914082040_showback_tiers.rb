class ShowbackTiers < ActiveRecord::Migration[5.0]
  def up
    create_table :showback_tiers do |t|
      t.bigint     :tier_start_value
      t.bigint     :tier_end_value
      t.bigint     :fixed_rate_subunits # Columns needed by gem money
      t.string     :fixed_rate_currency
      t.string     :fixed_rate_per_time
      t.bigint     :variable_rate_subunits # Columns needed by gem money
      t.string     :variable_rate_currency
      t.string     :variable_rate_per_unit
      t.string     :variable_rate_per_time
      t.float      :step_value
      t.string     :step_time_unit
      t.float      :step_time_value
      t.string     :step_unit

      t.belongs_to :showback_rates, :type => :bigint
    end

    remove_column    :showback_rates, :fixed_rate_subunits # Columns needed by gem money
    remove_column    :showback_rates, :fixed_rate_currency

    remove_column    :showback_rates, :variable_rate_subunits # Columns needed by gem money
    remove_column    :showback_rates, :variable_rate_currency
    remove_column    :showback_rates, :variable_rate_per_unit
    remove_column    :showback_rates, :variable_rate_per_time

    remove_column    :showback_rates, :step_value
    remove_column    :showback_rates, :step_time_unit
    remove_column    :showback_rates, :step_time_value
    remove_column    :showback_rates, :step_unit

    add_column       :showback_rates, :uses_single_tier,       :boolean
    add_column       :showback_rates, :tiers_use_full_value,  :boolean

    rename_column    :showback_rates, :fixed_rate_per_time, :step_variable
    rename_column    :showback_rates, :fixed_rate_per_unit, :measure
  end

  def down
    drop_table :showback_tiers

    add_column :showback_rates, :fixed_rate_subunits,    :bigint
    add_column :showback_rates, :fixed_rate_currency,    :string

    add_column :showback_rates, :variable_rate_subunits, :bigint
    add_column :showback_rates, :variable_rate_currency, :string
    add_column :showback_rates, :variable_rate_per_unit, :string
    add_column :showback_rates, :variable_rate_per_time, :string

    add_column :showback_rates, :step_value,             :float
    add_column :showback_rates, :step_time_unit,         :string
    add_column :showback_rates, :step_time_value,        :float
    add_column :showback_rates, :step_unit,              :string

    remove_column    :showback_rates, :uses_single_tier
    remove_column    :showback_rates, :tiers_use_full_value

    rename_column    :showback_rates, :step_variable, :fixed_rate_per_time
    rename_column    :showback_rates, :measure,  :fixed_rate_per_unit
  end
end
