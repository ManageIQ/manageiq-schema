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
    create_table_lines = schema.lines.grep(/^\s*create_table/)

    expect(create_table_lines.count).to eq(table_list.count), missing_table_failure_message

    table_list.each do |table_name|
      has_table = create_table_lines.detect { |l| l.include?(table_name) }
      expect(has_table).to be_truthy, "Table '#{table_name}' not found in schema\n#{missing_table_failure_message}"
    end
  end

  it "includes all id column comments" do
    id_comment_list  = %w[conversion_hosts miq_tasks vms]
    id_comment_lines = schema.lines.grep(/^\s*change_column_comment/)

    expect(id_comment_lines.count).to eq(id_comment_list.count)

    id_comment_list.each do |table_name|
      has_table = id_comment_lines.detect { |l| l.include?(table_name) }
      expect(has_table).to be_truthy, "comment not added for id in schema for '#{table_name}'"
    end
  end

  it "includes all metrics sequences" do
    miq_metric_sequences = schema.lines.grep(/^\s*change_miq_metric_sequence/)

    expect(miq_metric_sequences.count).to eq(metric_list.count + metric_rollup_list.count)

    combined_metric_list.each do |metric_subdivision|
      has_definition = miq_metric_sequences.detect { |l| l.include?(metric_subdivision) }
      expect(has_definition).to be_truthy, "change_miq_metric_sequence not defined for #{metric_subdivision}"
    end
  end

  it "includes all metrics table inheritence" do
    miq_metric_inheritances = schema.lines.grep(/^\s*add_miq_metric_table_inheritance/)

    expect(miq_metric_inheritances.count).to eq(metric_list.count + metric_rollup_list.count)

    combined_metric_list.each do |metric_subdivision|
      has_definition = miq_metric_inheritances.detect { |l| l.include?(metric_subdivision) }
      expect(has_definition).to be_truthy, "add_miq_metric_table_inheritance not defined for #{metric_subdivision}"
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
