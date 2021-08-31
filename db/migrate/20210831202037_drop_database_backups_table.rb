class DropDatabaseBackupsTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :database_backups
  end

  def down
    create_table "database_backups", :force => :cascade do |t|
      t.string   "name"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
end
