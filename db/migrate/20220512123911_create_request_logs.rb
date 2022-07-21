class CreateRequestLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :request_logs do |t|
      t.string :log_message
      t.string :object_type
      t.bigint :object_id
      t.timestamps
    end
  end
end
