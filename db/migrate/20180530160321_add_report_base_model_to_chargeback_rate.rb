class AddReportBaseModelToChargebackRate < ActiveRecord::Migration[5.0]
  def change
    add_column :chargeback_rates, :report_base_model, :string
  end
end
