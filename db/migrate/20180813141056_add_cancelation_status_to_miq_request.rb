class AddCancelationStatusToMiqRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :miq_requests,      :cancelation_status, :string
    add_column :miq_request_tasks, :cancelation_status, :string
  end
end
