class AddMetricsDiskReadWriteLatency < ActiveRecord::Migration[6.0]
  include MigrationHelper

  DISK_LATENCY_METRIC_COLUMNS = %i[
    disk_totalreadlatency_absolute_average
    disk_totalwritelatency_absolute_average
  ].freeze

  def up
    recreate_metrics_views do
      add_disk_latency_metric_columns("metrics_base")
      add_disk_latency_metric_columns("metric_rollups_base")
    end
  end

  def down
    recreate_metrics_views do
      remove_disk_latency_metric_columns("metrics_base")
      remove_disk_latency_metric_columns("metric_rollups_base")
    end
  end

  def add_disk_latency_metric_columns(table_name)
    DISK_LATENCY_METRIC_COLUMNS.each do |column_name|
      add_column table_name, column_name, :float
    end
  end

  def remove_disk_latency_metric_columns(table_name)
    DISK_LATENCY_METRIC_COLUMNS.each do |column_name|
      remove_column table_name, column_name
    end
  end
end
