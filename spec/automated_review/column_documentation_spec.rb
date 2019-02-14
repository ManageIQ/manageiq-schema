describe "Column documentation" do
  # Documented tables
  %w[conversion_hosts miq_tasks].each do |table_name|
    it "#{table_name} columns are documented" do
      klass = Class.new(ActiveRecord::Base) do
        self.table_name = table_name
      end

      klass.columns.each do |column|
        expect(column.comment).not_to be_nil, "#{table_name}##{column.name} is not documented."
      end
    end
  end
end
