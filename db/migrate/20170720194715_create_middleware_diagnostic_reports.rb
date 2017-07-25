class CreateMiddlewareDiagnosticReports < ActiveRecord::Migration[5.0]
  def change
    create_table :middleware_diagnostic_reports do |t|
      t.datetime :queued_at
      t.string :requesting_user
      t.string :status
      t.string :error_message
      t.references(:middleware_server, :type => :bigint)
      t.timestamps
    end
  end
end
