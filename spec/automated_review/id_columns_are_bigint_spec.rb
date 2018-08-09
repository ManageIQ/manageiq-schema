require 'set'
describe "*_id columns" do
  EXCEPTIONS_LIST = Set.new(
    [
      "authentications.ldap_id",
      "authentications.rhsm_pool_id",
      "cloud_networks.provider_segmentation_id",
      "container_volumes.common_volume_id",
      "miq_queue.task_id",
      "network_ports.binding_host_id",
      "scan_histories.task_id",
      "sessions.session_id"
    ]
  ).freeze

  it "should be type bigint" do
    ActiveRecord::Base.connection.tables.each do |table|
      next if ManageIQ::Schema::SYSTEM_TABLES.include?(table)
      DatabaseHelper.columns_for_table(table).each do |column|
        next unless column.name.end_with?("_id")
        if "#{table}.#{column.name}".in?(EXCEPTIONS_LIST)
          expect(column.sql_type).not_to eq("bigint"), "Thanks for fixing technical debt!!! Please remove '#{table}.#{column.name}' from EXCEPTIONS_LIST in #{__FILE__}"
        else
          expect(column.sql_type).to eq("bigint"), "Expected foreign key column #{table}.#{column.name} to be type 'bigint', got: '#{column.sql_type}'"
        end
      end
    end
  end
end

describe "id columns" do
  it "should be type bigint" do
    ActiveRecord::Base.connection.tables.each do |table|
      next if ManageIQ::Schema::SYSTEM_TABLES.include?(table)
      DatabaseHelper.columns_for_table(table).each do |column|
        next unless column.name == "id"
        expect(column.sql_type).to eq("bigint"), "Expected column #{table}.#{column.name} to be type 'bigint', got: '#{column.sql_type}'"
      end
    end
  end
end
