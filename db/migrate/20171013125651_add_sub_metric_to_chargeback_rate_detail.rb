class AddSubMetricToChargebackRateDetail < ActiveRecord::Migration[5.0]
  def change
    add_column :chargeback_rate_details, :sub_metric, :string
  end
end
