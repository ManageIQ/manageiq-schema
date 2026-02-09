describe "SchemaDumper" do
  SCHEMA_RB_FILE  = File.expand_path("../dummy/db/schema.rb", __dir__)
  TABLE_LIST_FILE = File.expand_path("../support/table_list.txt", __dir__)

  let(:combined_metric_list) { metric_rollup_list + metric_list }
  let(:metric_list)          { (0..23).to_a.map { |num| "metrics_#{num.to_s.rjust(2, '0')}" } }
  let(:metric_rollup_list)   { (1..12).to_a.map { |num| "metric_rollups_#{num.to_s.rjust(2, '0')}" } }
  let(:table_list)           { File.read(TABLE_LIST_FILE).lines.map(&:strip) }
  let(:schema)               { File.read(SCHEMA_RB_FILE) }

  let(:missing_table_failure_message) do
    <<~MSG.lines.map(&:strip).join(" ").prepend("\n")
      If this spec failed and a new migration was added that adds/removes a
      table, please run `spec:table_list` to ensure that `table_list.txt` is up
      to date with the newest schema.
    MSG
  end

  it "includes all of the manageiq tables" do
    create_tables = schema.scan(/^\s*create_table "([^"]+)"/).flatten

    expect(create_tables.count).to eq(table_list.count), missing_table_failure_message

    table_list.each do |table_name|
      expect(create_tables).to include(table_name), "Table '#{table_name}' not found in schema\n#{missing_table_failure_message}"
    end
  end

  it "includes all id column comments" do
    id_comment_list = %w[miq_tasks vms]
    id_comments     = schema.scan(/^\s*change_column_comment "([^"]+)"/).flatten

    expect(id_comments.count).to eq(id_comment_list.count)

    id_comment_list.each do |table_name|
      expect(id_comments).to include(table_name), "comment not added for id in schema for '#{table_name}'"
    end
  end

  it "includes all metrics sequences" do
    metric_sequences = schema.scan(/^\s*change_miq_metric_sequence "([^"]+)"/).flatten

    expect(metric_sequences.count).to eq(metric_list.count + metric_rollup_list.count)

    combined_metric_list.each do |metric_subdivision|
      expect(metric_sequences).to include(metric_subdivision), "change_miq_metric_sequence not defined for #{metric_subdivision}"
    end
  end

  context "metrics table inheritance" do
    it "dumps INHERITS the correct number of times per base metric table" do
      expect(schema.scan('INHERITS (metrics_base)').flatten.count).to eq(24)        # 24 hours per day   - 1 subtable each
      expect(schema.scan('INHERITS (metric_rollups_base)').flatten.count).to eq(12) # 12 months per year - 1 subtable each
    end

    it "Creates the base metrics tables first and the subtables last" do
      first, second, *rest = schema.scan(/create_table.+[^\w]+metric\w+/)
      expect(first).to match(/metric_rollups_base/)
      expect(second).to match(/metrics_base/)
      expect(rest.grep(/metric_rollups_[0-9]/).count).to eq(12) # 12 months per year - 1 subtable each
      expect(rest.grep(/metrics_[0-9]/).count).to eq(24)        # 24 hours per day   - 1 subtable each
    end
  end

  it "includes all views" do
    relevant_schema_lines = schema.lines.grep(/create_miq_metric_view/).join

    expect(relevant_schema_lines).to include 'create_miq_metric_view "metrics"'
    expect(relevant_schema_lines).to include 'create_miq_metric_view "metric_rollups"'
  end

  it "includes all triggers" do
    relevant_schema_lines = schema.lines.grep(/add_trigger/).join

    expect(relevant_schema_lines).to include 'add_trigger "insteadof", "metrics", "metrics_partition",'
    expect(relevant_schema_lines).to include 'add_trigger "insteadof", "metric_rollups", "metric_rollups_partition",'
  end
end
