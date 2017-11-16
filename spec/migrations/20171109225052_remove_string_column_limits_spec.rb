require_migration

describe RemoveStringColumnLimits do
  let(:connection) { ActiveRecord::Base.connection }
  let(:table_name) { "remove_string_column_limits" }

  migration_context :up do
    it "removes the limit from string columns" do
      connection.execute(<<-SQL)
        CREATE TABLE #{table_name} (id bigint, string varchar(255), other_string varchar(36), more_string varchar)
      SQL

      migrate

      columns_by_name = connection.columns(table_name).each_with_object({}) do |col, hash|
        hash[col.name] = col
      end

      expect(columns_by_name["id"].limit).to eq(8)
      expect(columns_by_name["string"].limit).to be_nil
      expect(columns_by_name["other_string"].limit).to be_nil
      expect(columns_by_name["more_string"].limit).to be_nil
    end
  end
end
