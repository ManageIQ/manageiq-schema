class AddCommentsToMiqTasksTable < ActiveRecord::Migration[5.0]
  def up
    change_table_comment :miq_tasks, "ManageIQ background tasks"

    change_column_comment :miq_tasks, :context_data, "Serialized metadata that may contain more detailed information about the task."
    change_column_comment :miq_tasks, :created_on, "[builtin] The timestamp the record was created."
    change_column_comment :miq_tasks, :id, "[builtin] The internal record ID. This is the primary key."
    change_column_comment :miq_tasks, :identifier, "The resource this task is related to in 'class:id' format."
    change_column_comment :miq_tasks, :message, "Message associated with the task for logging or UI purposes."
    change_column_comment :miq_tasks, :miq_server_id, "The ID of the ManageIQ server where the task was executed."
    change_column_comment :miq_tasks, :name, "The name of the task. Typically doubles as a description."
    change_column_comment :miq_tasks, :pct_complete, "The current completion percentage of the task."
    change_column_comment :miq_tasks, :results, "Task execution result. Deprecated."
    change_column_comment :miq_tasks, :started_on, "The timestamp the task was actually started."
    change_column_comment :miq_tasks, :state, "The current state of the task - Initialized, Queued, Active, Finished, etc."
    change_column_comment :miq_tasks, :status, "The current status of the task - Ok, Warn, Error, Timeout, Expired, or Unknown."
    change_column_comment :miq_tasks, :updated_on, "[builtin] The timestamp the record was last updated."
    change_column_comment :miq_tasks, :userid, "The userid that created the task, or 'system' if created by the appliance."
    change_column_comment :miq_tasks, :zone, "The zone in which the task should be executed, or any zone if null."
  end
end
