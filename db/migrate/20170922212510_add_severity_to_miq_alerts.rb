class AddSeverityToMiqAlerts < ActiveRecord::Migration[5.0]
  def change
    add_column :miq_alerts, :severity, :string
  end
end
