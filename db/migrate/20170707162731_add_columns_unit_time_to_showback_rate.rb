class AddColumnsUnitTimeToShowbackRate < ActiveRecord::Migration[5.0]
  def change
    add_column :showback_rates, :fixed_rate_per_unit,    :string
    add_column :showback_rates, :fixed_rate_per_time,    :string
    add_column :showback_rates, :variable_rate_per_unit, :string
    add_column :showback_rates, :variable_rate_per_time, :string
    add_column :showback_rates, :step_value,             :float
    add_column :showback_rates, :step_time_unit,         :string
    add_column :showback_rates, :step_time_value,        :float
    add_column :showback_rates, :step_unit,              :string
  end
end
