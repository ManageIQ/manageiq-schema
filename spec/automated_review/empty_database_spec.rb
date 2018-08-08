describe "Empty Database" do
  it "after migrated remains empty" do
    counts = ActiveRecord::Base.connection.tables.each_with_object([]) do |t, array|
      next if ManageIQ::Schema::SYSTEM_TABLES.include?(t)
      count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM #{t};").getvalue(0, 0)
      array << "#{t}: #{count}" if count.positive?
    end

    expect(counts.size).to eq(0), "Records were found in the following tables:\n#{counts.join("\n")}"
  end
end
