class UseViewsForMetrics < ActiveRecord::Migration[5.0]
  include MigrationHelper

  def up
    # Drop the triggers
    drop_trigger "metrics", "metrics_inheritance_before"
    drop_trigger "metrics", "metrics_inheritance_after"
    drop_trigger "metric_rollups", "metric_rollups_inheritance_before"
    drop_trigger "metric_rollups", "metric_rollups_inheritance_after"

    # Rename the old base table
    rename_table :metrics, :metrics_base
    rename_table :metric_rollups, :metric_rollups_base

    # Create the view with the new table name
    create_view "metrics"
    create_view "metric_rollups"

    # Add the new trigger on the view
    add_trigger "insteadof", "metrics", "metrics_partition", metrics_trigger_sql
    add_trigger "insteadof", "metric_rollups", "metric_rollups_partition", metric_rollups_trigger_sql
  end

  def down
    # Drop the view triggers
    drop_trigger "metrics", "metrics_partition"
    drop_trigger "metric_rollups", "metric_rollups_partition"

    # Drop the views
    drop_view "metrics"
    drop_view "metric_rollups"

    # Rename the tables back to the original name
    rename_table :metrics_base, :metrics
    rename_table :metric_rollups_base, :metric_rollups

    # Add the original triggers back to the base tables
    add_metrics_inheritance_triggers
    add_metric_rollups_inheritance_triggers
  end

  private

  def create_view(name)
    execute(<<-SQL)
      CREATE VIEW #{name} AS SELECT * FROM #{name}_base
    SQL
    execute(<<-SQL)
      ALTER VIEW #{name} ALTER COLUMN id SET DEFAULT nextval('#{name}_base_id_seq')
    SQL
  end

  def drop_view(name)
    execute(<<-SQL)
      DROP VIEW #{name}
    SQL
  end

  def metrics_trigger_sql
    <<-SQL
      CASE EXTRACT(HOUR FROM NEW.timestamp)
        WHEN 0 THEN
          INSERT INTO metrics_00 VALUES (NEW.*);
        WHEN 1 THEN
          INSERT INTO metrics_01 VALUES (NEW.*);
        WHEN 2 THEN
          INSERT INTO metrics_02 VALUES (NEW.*);
        WHEN 3 THEN
          INSERT INTO metrics_03 VALUES (NEW.*);
        WHEN 4 THEN
          INSERT INTO metrics_04 VALUES (NEW.*);
        WHEN 5 THEN
          INSERT INTO metrics_05 VALUES (NEW.*);
        WHEN 6 THEN
          INSERT INTO metrics_06 VALUES (NEW.*);
        WHEN 7 THEN
          INSERT INTO metrics_07 VALUES (NEW.*);
        WHEN 8 THEN
          INSERT INTO metrics_08 VALUES (NEW.*);
        WHEN 9 THEN
          INSERT INTO metrics_09 VALUES (NEW.*);
        WHEN 10 THEN
          INSERT INTO metrics_10 VALUES (NEW.*);
        WHEN 11 THEN
          INSERT INTO metrics_11 VALUES (NEW.*);
        WHEN 12 THEN
          INSERT INTO metrics_12 VALUES (NEW.*);
        WHEN 13 THEN
          INSERT INTO metrics_13 VALUES (NEW.*);
        WHEN 14 THEN
          INSERT INTO metrics_14 VALUES (NEW.*);
        WHEN 15 THEN
          INSERT INTO metrics_15 VALUES (NEW.*);
        WHEN 16 THEN
          INSERT INTO metrics_16 VALUES (NEW.*);
        WHEN 17 THEN
          INSERT INTO metrics_17 VALUES (NEW.*);
        WHEN 18 THEN
          INSERT INTO metrics_18 VALUES (NEW.*);
        WHEN 19 THEN
          INSERT INTO metrics_19 VALUES (NEW.*);
        WHEN 20 THEN
          INSERT INTO metrics_20 VALUES (NEW.*);
        WHEN 21 THEN
          INSERT INTO metrics_21 VALUES (NEW.*);
        WHEN 22 THEN
          INSERT INTO metrics_22 VALUES (NEW.*);
        WHEN 23 THEN
          INSERT INTO metrics_23 VALUES (NEW.*);
      END CASE;
      RETURN NEW;
    SQL
  end

  def metric_rollups_trigger_sql
    <<-SQL
      CASE EXTRACT(MONTH FROM NEW.timestamp)
        WHEN 1 THEN
          INSERT INTO metric_rollups_01 VALUES (NEW.*);
        WHEN 2 THEN
          INSERT INTO metric_rollups_02 VALUES (NEW.*);
        WHEN 3 THEN
          INSERT INTO metric_rollups_03 VALUES (NEW.*);
        WHEN 4 THEN
          INSERT INTO metric_rollups_04 VALUES (NEW.*);
        WHEN 5 THEN
          INSERT INTO metric_rollups_05 VALUES (NEW.*);
        WHEN 6 THEN
          INSERT INTO metric_rollups_06 VALUES (NEW.*);
        WHEN 7 THEN
          INSERT INTO metric_rollups_07 VALUES (NEW.*);
        WHEN 8 THEN
          INSERT INTO metric_rollups_08 VALUES (NEW.*);
        WHEN 9 THEN
          INSERT INTO metric_rollups_09 VALUES (NEW.*);
        WHEN 10 THEN
          INSERT INTO metric_rollups_10 VALUES (NEW.*);
        WHEN 11 THEN
          INSERT INTO metric_rollups_11 VALUES (NEW.*);
        WHEN 12 THEN
          INSERT INTO metric_rollups_12 VALUES (NEW.*);
      END CASE;
      RETURN NEW;
    SQL
  end

  def add_metrics_inheritance_triggers
    add_trigger "before", "metrics", "metrics_inheritance_before", metrics_trigger_sql
    add_trigger "after", "metrics", "metrics_inheritance_after", <<-EOSQL
      DELETE FROM ONLY metrics WHERE id = NEW.id;
      RETURN NEW;
    EOSQL
  end

  def add_metric_rollups_inheritance_triggers
    add_trigger "before", "metric_rollups", "metric_rollups_inheritance_before", metric_rollups_trigger_sql
    add_trigger "after", "metric_rollups", "metric_rollups_inheritance_after", <<-EOSQL
      DELETE FROM ONLY metric_rollups WHERE id = NEW.id;
      RETURN NEW;
    EOSQL
  end
end
