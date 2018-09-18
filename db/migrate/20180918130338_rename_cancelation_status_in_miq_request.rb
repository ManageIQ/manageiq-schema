class RenameCancelationStatusInMiqRequest < ActiveRecord::Migration[5.0]
  def change
    rename_column :miq_requests,      :cancelation_status, :cancellation_status
    rename_column :miq_request_tasks, :cancelation_status, :cancellation_status
  end
end
