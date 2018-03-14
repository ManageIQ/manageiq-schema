class LinkQueueAndTask < ActiveRecord::Migration[5.0]
  def change
    add_reference :miq_queue, :miq_task, :type => :bigint
  end
end
