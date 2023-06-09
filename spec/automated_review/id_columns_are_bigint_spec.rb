require 'set'

describe "*_id columns" do
  let(:exceptions_list) do
    Set.new(%w[
      cloud_networks.provider_segmentation_id
      container_volumes.common_volume_id
      miq_queue.task_id
      network_ports.binding_host_id
      scan_histories.task_id
      sessions.session_id
    ])
  end

  it "should be type bigint" do
    not_bigint = []
    no_longer_exceptions = []

    ActiveRecord::Base.connection.tables.each do |table|
      next if ManageIQ::Schema::SYSTEM_TABLES.include?(table)

      DatabaseHelper.columns_for_table(table).each do |column|
        next unless column.name.end_with?("_id")

        fq_column_name = "#{table}.#{column.name}"

        if fq_column_name.in?(exceptions_list)
          no_longer_exceptions << fq_column_name if column.sql_type == "bigint"
        else
          not_bigint << fq_column_name unless column.sql_type == "bigint"
        end
      end
    end

    expect(no_longer_exceptions).to be_empty, "Thanks for fixing technical debt!!! Please remove the following foreign key columns from EXCEPTIONS_LIST in #{__FILE__}:\n\n#{no_longer_exceptions.join("\n")}"
    expect(not_bigint).to be_empty, "Expected the following foreign key columns to be type 'bigint':\n\n#{not_bigint.join("\n")}"
  end
end

describe "id columns" do
  it "should be type bigint" do
    not_bigint = []

    ActiveRecord::Base.connection.tables.sort.each do |table|
      next if ManageIQ::Schema::SYSTEM_TABLES.include?(table)

      DatabaseHelper.columns_for_table(table).each do |column|
        next unless column.name == "id"

        fq_column_name = "#{table}.#{column.name}"

        not_bigint << fq_column_name unless column.sql_type == "bigint"
      end
    end

    expect(not_bigint).to be_empty, "Expected the following foreign key columns to be type 'bigint':\n\n#{not_bigint.join("\n")}"
  end
end
