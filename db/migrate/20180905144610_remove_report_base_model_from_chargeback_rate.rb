class RemoveReportBaseModelFromChargebackRate < ActiveRecord::Migration[5.0]
  def change
    remove_column :chargeback_rates, :report_base_model, :string
  end
end
