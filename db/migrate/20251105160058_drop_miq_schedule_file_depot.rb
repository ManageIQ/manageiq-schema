class DropMiqScheduleFileDepot < ActiveRecord::Migration[7.2]
  def change
    remove_column :miq_schedules, :file_depot_id, :bigint
  end
end
