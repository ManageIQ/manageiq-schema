class CreateRefreshQueueTable < ActiveRecord::Migration[5.0]
  def change
    create_table :refresh_queue do |t|

      t.string "class_name"
      t.jsonb "persister_data", default: {}

      t.string "zone"
      t.string "role"
      t.string "server_guid"

      t.datetime "created_on"
      t.datetime "expires_on"
    end
  end
end
