class RemoveStringColumnLimits < ActiveRecord::Migration[5.0]
  def up
    connection.tables.sort.each do |t|
      connection.columns(t).each do |col|
        next unless col.type == :string && !col.limit.nil?
        change_column t, col.name, :string, :limit => nil
      end
    end
  end
end
