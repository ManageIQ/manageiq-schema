module DatabaseHelper
  def self.columns_for_table(table_name)
    ActiveRecord::Base.connection.data_source_exists?(table_name) ? ActiveRecord::Base.connection.columns(table_name).sort_by(&:name) : []
  end

  def self.indexes_for_table(table_name)
    ActiveRecord::Base.connection.data_source_exists?(table_name) ? ActiveRecord::Base.connection.indexes(table_name).sort_by(&:name) : []
  end

  def self.table_has_type_column?(table_name)
    columns_for_table(table_name).detect { |i| i.name == "type" }
  end
end
