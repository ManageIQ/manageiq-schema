class AddMetricsDiskReadWriteLatency < ActiveRecord::Migration[6.0]
  include MigrationHelper

  DISK_LATENCY_METRIC_COLUMNS = %i[
    disk_devicereadlatency_absolute_average
    disk_kernelreadlatency_absolute_average
    disk_totalreadlatency_absolute_average
    disk_queuereadlatency_absolute_average
    disk_devicewritelatency_absolute_average
    disk_kernelwritelatency_absolute_average
    disk_totalwritelatency_absolute_average
    disk_queuewritelatency_absolute_average
  ].freeze

  def up
    drop_view("metrics")
    drop_view("metric_rollups")

    add_disk_latency_metric_columns("metrics_base")
    add_disk_latency_metric_columns("metric_rollups_base")

    create_view("metrics")
    create_view("metric_rollups")
  end

  def down
    drop_view("metrics")
    drop_view("metric_rollups")

    remove_disk_latency_metric_columns("metrics_base")
    remove_disk_latency_metric_columns("metric_rollups_base")

    create_view("metrics")
    create_view("metric_rollups")
  end

  def add_disk_latency_metric_columns(table_name)
    say_with_time("Adding disk read/write latency to #{table_name}") do
      DISK_LATENCY_METRIC_COLUMNS.each do |column_name|
        add_column table_name, column_name, :float
      end
    end
  end

  def remove_disk_latency_metric_columns(table_name)
    say_with_time("Adding disk read/write latency to #{table_name}") do
      DISK_LATENCY_METRIC_COLUMNS.each do |column_name|
        remove_column table_name, column_name
      end
    end
  end
end
