class RenameChargebackRateDetailCurrencyToCurrency < ActiveRecord::Migration[5.1]
  def change
    rename_table :chargeback_rate_detail_currencies, :currencies
  end
end
