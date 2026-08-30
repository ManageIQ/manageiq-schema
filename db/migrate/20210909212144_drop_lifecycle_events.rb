class DropLifecycleEvents < ActiveRecord::Migration[6.0]
  def up
    drop_table :lifecycle_events
  end

  def down
    create_table "lifecycle_events", force: :cascade do |t|
      t.string "guid"
      t.string "status"
      t.string "event"
      t.string "message"
      t.string "location"
      t.bigint "vm_or_template_id"
      t.string "created_by"
      t.datetime "created_on"
      t.index ["guid"], name: "index_lifecycle_events_on_guid", unique: true
      t.index ["vm_or_template_id"], name: "index_lifecycle_events_on_vm_id"
    end
  end
end
