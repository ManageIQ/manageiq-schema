class MetricsSequences < ActiveRecord::Migration[5.0]
  include MigrationHelper
  def up
    change_sequences("metrics", 0..23, false)
    change_sequences("metric_rollups", 1..12, false)
  end

  def down
    change_sequences("metrics", 0..23, true)
    change_sequences("metric_rollups", 1..12, true)
  end

  # @param table_name [String] base table name to inherit from
  # @param range [Range] range of subtables
  # @param unique [Boolean] true if each table gets a unique sequence,
  #                         false if they use the base table's sequence
  def change_sequences(table_name, range, unique = true)
    range.each do |n|
      s = subtable_name(table_name, n)
      execute("CREATE SEQUENCE #{s}_id_seq") if unique
      change_column_default(s, :id, -> { "nextval('#{unique ? s : table_name}_id_seq')" })
      execute("DROP SEQUENCE #{s}_id_seq") unless unique
    end
  end

  def subtable_name(inherit_from, index)
    "#{inherit_from}_#{index.to_s.rjust(2, '0')}"
  end
end
