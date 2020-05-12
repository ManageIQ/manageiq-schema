class RemoveVmdbDatabaseTables < ActiveRecord::Migration[5.2]
  def up
    drop_table :vmdb_database_metrics
    drop_table :vmdb_databases
    drop_table :vmdb_indexes
    drop_table :vmdb_metrics
    drop_table :vmdb_tables
  end

  def down
    create_table "vmdb_database_metrics", force: :cascade do |t|
      t.bigint "vmdb_database_id"
      t.integer "running_processes"
      t.integer "active_connections"
      t.datetime "timestamp"
      t.string "capture_interval_name"
      t.bigint "disk_total_bytes"
      t.bigint "disk_free_bytes"
      t.bigint "disk_used_bytes"
      t.bigint "disk_total_inodes"
      t.bigint "disk_used_inodes"
      t.bigint "disk_free_inodes"
    end

    create_table "vmdb_databases", force: :cascade do |t|
      t.string "name"
      t.string "ipaddress"
      t.string "vendor"
      t.string "version"
      t.string "data_directory"
      t.datetime "last_start_time"
      t.string "data_disk"
    end

    create_table "vmdb_indexes", force: :cascade do |t|
      t.bigint "vmdb_table_id"
      t.string "name"
      t.text "prior_raw_metrics"
    end

    create_table "vmdb_metrics", force: :cascade do |t|
      t.bigint "resource_id"
      t.string "resource_type"
      t.bigint "size"
      t.bigint "rows"
      t.bigint "pages"
      t.float "percent_bloat"
      t.float "wasted_bytes"
      t.integer "otta"
      t.bigint "table_scans"
      t.bigint "sequential_rows_read"
      t.bigint "index_scans"
      t.bigint "index_rows_fetched"
      t.bigint "rows_inserted"
      t.bigint "rows_updated"
      t.bigint "rows_deleted"
      t.bigint "rows_hot_updated"
      t.bigint "rows_live"
      t.bigint "rows_dead"
      t.datetime "last_vacuum_date"
      t.datetime "last_autovacuum_date"
      t.datetime "last_analyze_date"
      t.datetime "last_autoanalyze_date"
      t.datetime "timestamp"
      t.string "capture_interval_name"
      t.index ["resource_id", "resource_type", "timestamp"], name: "index_vmdb_metrics_on_resource_and_timestamp"
    end

    create_table "vmdb_tables", force: :cascade do |t|
      t.bigint "vmdb_database_id"
      t.string "name"
      t.string "type"
      t.bigint "parent_id"
      t.text "prior_raw_metrics"
      t.index ["type"], name: "index_vmdb_tables_on_type"
    end
  end
end
