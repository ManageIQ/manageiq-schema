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
    create_metrics_view "metrics"
    create_metrics_view "metric_rollups"

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
