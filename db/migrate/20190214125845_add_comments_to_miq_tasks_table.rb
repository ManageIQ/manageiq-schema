class AddCommentsToMiqTasksTable < ActiveRecord::Migration[5.0]
  def up
    change_table_comment :miq_tasks, "ManageIQ background tasks"

    change_column_comment :miq_tasks, :id, "The internal database ID."
    change_column_comment :miq_tasks, :name, "The name of the task. Typically doubles as a description."
    change_column_comment :miq_tasks, :state, "The current state of the task - Initialized, Queued, Active, or Finished."
    change_column_comment :miq_tasks, :status, "The current status of the task - Ok, Warn, Error, Timeout, Expired, or Unknown."
    change_column_comment :miq_tasks, :message, "Message that describes the reason for the current status."
    change_column_comment :miq_tasks, :userid, "The userid that created the task, or 'system' if created by the appliance."
    change_column_comment :miq_tasks, :created_on, "The timestamp the task was added to the app inventory."
    change_column_comment :miq_tasks, :updated_on, "The timestamp the task was last updated within the appliance."
    change_column_comment :miq_tasks, :pct_complete, "The current completion percentage of the task."
    change_column_comment :miq_tasks, :context_data, "Serialized metadata that may contain more detailed information about the task."
    change_column_comment :miq_tasks, :results, "TODO"
    change_column_comment :miq_tasks, :miq_server_id, "ID of the ManageIQ server that the task belongs to."
    change_column_comment :miq_tasks, :identifier, "TODO"
    change_column_comment :miq_tasks, :started_on, "The timestamp the task was actually started."
    change_column_comment :miq_tasks, :zone, "The zone of the request that created the task."
  end
end
