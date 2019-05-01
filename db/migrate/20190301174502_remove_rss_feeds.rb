class RemoveRssFeeds < ActiveRecord::Migration[5.0]
  def up
    drop_table :rss_feeds
  end

  def down
    create_table "rss_feeds" do |t|
      t.string   "name"
      t.text     "title"
      t.text     "link"
      t.text     "description"
      t.datetime "created_on"
      t.datetime "updated_on"
      t.datetime "yml_file_mtime"
    end

    add_index "rss_feeds", ["name"], :name => "index_rss_feeds_on_name"
  end
end
