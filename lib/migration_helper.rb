require 'pp'

# MigrationHelper is a module that can be included into migrations to add
# additional helper methods, thus eliminating some duplication and database
# specific coding.
#
# If mixed into a non-migration class, the module expects the following methods
# to be defined as in a migration: connection, say, say_with_time.  Additionally,
# any "extension" methods will need the original method defined.  For example,
# remove_index_ex expects remove_index to be defined.
module MigrationHelper
  def sanitize_sql_for_conditions(conditions)
    Object.const_set(:DummyActiveRecordForMigrationHelper, Class.new(ActiveRecord::Base)) unless defined?(::DummyActiveRecordForMigrationHelper)
    DummyActiveRecordForMigrationHelper.send(:sanitize_sql_for_conditions, conditions)
  end

  #
  # Batching
  #

  def say_batch_started(count)
    say "Processing #{count} rows", :subitem
    @batch_mutex ||= Mutex.new
    @batch_total_started = Time.now.utc
    @batch_started = Time.now.utc
    @batch_total = count
    @batch_count = 0
  end

  def say_batch_processed(count)
    @batch_mutex.synchronize do
      if count > 0
        @batch_count += count

        progress = @batch_count / @batch_total.to_f * 100
        timing   = Time.now.utc - @batch_started
        estimate = estimate_batch_complete(@batch_total_started, progress)

        say "#{count} rows (#{"%.2f" % progress}% - #{@batch_count} total - #{"%.2f" % timing}s - ETA: #{estimate})", :subitem
      end

      @batch_started = Time.now.utc
      @batch_count
    end
  end

  def estimate_batch_complete(start_time, progress)
    klass = Class.new { extend ActionView::Helpers::DateHelper }
    estimated_end_time = start_time + (Time.now.utc - start_time) / (progress / 100.0)
    klass.distance_of_time_in_words(Time.now.utc, estimated_end_time, :include_seconds => true)
  end
  private :estimate_batch_complete

  #
  # Views
  #

  def create_view(name, query, sequence)
    say_with_time("create_view(:#{name}, :#{sequence})") do
      execute("CREATE VIEW #{name} AS #{query}")
      execute("ALTER VIEW #{name} ALTER COLUMN id SET DEFAULT nextval('#{sequence}')")
    end
  end

  def create_metrics_view(name)
    create_view(name, "SELECT * FROM #{name}_base", "#{name}_base_id_seq")
  end

  def drop_view(name)
    say_with_time("drop_view(:#{name})") do
      execute("DROP VIEW #{name}")
    end
  end

  def recreate_metrics_views
    drop_view("metrics")
    drop_view("metric_rollups")

    yield

    create_metrics_view("metrics")
    create_metrics_view("metric_rollups")

    add_trigger "insteadof", "metrics", "metrics_partition", metrics_trigger_sql
    add_trigger "insteadof", "metric_rollups", "metric_rollups_partition", metric_rollups_trigger_sql
  end

  #
  # Triggers
  #

  # Keeping this helper to suppress the SQL body from the `say_with_time` output
  def add_trigger(direction, table, name, body)
    say_with_time("add_trigger(:#{direction}, :#{table}, :#{name})") do
      connection.add_trigger(direction, table, name, body)
    end
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

  #
  # Table inheritance
  #
  # (note:  Can't remove because it is used in CollapsedInitialMigration and
  # this method was renamed in MiqSchemaStatements.  Renaming might have been a
  # poor choice...)
  #

  def add_table_inheritance(table, inherit_from, options = {})
    quoted_table = connection.quote_table_name(table)
    quoted_inherit = connection.quote_table_name(inherit_from)
    quoted_constraint = connection.quote_column_name("#{table}_inheritance_check")

    say_with_time("add_table_inheritance(:#{table}, :#{inherit_from})") do
      conditions = sanitize_sql_for_conditions(options[:conditions])
      connection.execute("ALTER TABLE #{quoted_table} ADD CONSTRAINT #{quoted_constraint} CHECK (#{conditions})", 'Add inheritance check constraint')
      connection.execute("ALTER TABLE #{quoted_table} INHERIT #{quoted_inherit}", 'Add table inheritance')
    end
  end

  def drop_table_inheritance(table, inherit_from)
    quoted_table = connection.quote_table_name(table)
    quoted_inherit = connection.quote_table_name(inherit_from)
    quoted_constraint = connection.quote_column_name("#{table}_inheritance_check")

    say_with_time("drop_table_inheritance(:#{table}, :#{inherit_from})") do
      connection.execute("ALTER TABLE #{quoted_table} DROP CONSTRAINT #{quoted_constraint}", 'Drop inheritance check constraint')
      connection.execute("ALTER TABLE #{quoted_table} NO INHERIT #{quoted_inherit}", 'Drop table inheritance')
    end
  end

  def rename_class_references(mapping)
    reversible do |dir|
      dir.down { mapping = mapping.invert }

      condition_list = ""
      mapping.each_key { |s| condition_list << connection.quote(s) << "," }
      condition_list.chomp!(",")
      when_clauses = ""
      mapping.each { |before, after| when_clauses << "WHEN #{connection.quote(before)} THEN #{connection.quote(after)} " }
      when_clauses.chomp!(" ")

      say "Renaming class references:\n#{mapping.pretty_inspect}"

      rows = say_with_time("Determining tables and columns for update") do
        connection.select_rows(
          <<-SQL
            SELECT pg_class.oid::regclass::text, quote_ident(attname)
            FROM pg_class JOIN pg_attribute ON pg_class.oid = attrelid
            WHERE relkind = 'r'
              AND (attname = 'type' OR attname LIKE '%\\_type')
              AND atttypid IN ('text'::regtype, 'varchar'::regtype)
            ORDER BY relname, attname
          SQL
        )
      end

      rows.each do |table, column|
        quoted_table  = connection.quote_table_name(table)
        quoted_column = connection.quote_column_name(column)

        say_with_time("Renaming class reference in #{quoted_table}.#{quoted_column}") do
          connection.execute(
            <<-SQL
              UPDATE #{quoted_table}
              SET #{quoted_column} = CASE #{quoted_column} #{when_clauses} END
              WHERE #{quoted_column} IN (#{condition_list})
            SQL
          )
        end
      end
    end
  end

  # Fixes issues where migrations were named incorrectly due to issues with the
  #   naming of 20150823120001_namespace_ems_openstack_availability_zones_null.rb
  def previously_migrated_as?(bad_date)
    connection.exec_delete(
      "DELETE FROM schema_migrations WHERE version = #{connection.quote(bad_date)}"
    ) > 0
  end
end
