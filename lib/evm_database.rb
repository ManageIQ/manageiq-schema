class EvmDatabase
  SCHEMA_FILE = ManageIQ::Schema::Engine.root.join("db/schema.yml").freeze

  # Determines if the schema currently being used is the same as the one we expect
  #
  # @param connection Check the database at this connection against the local file
  # @return nil if the schemas match, an error message otherwise
  def self.check_schema(connection = ActiveRecord::Base.connection)
    check_schema_tables(connection) || check_schema_columns(connection)
  end

  # Writes the schema to SCHEMA_FILE as it currently exists in the database
  #
  # @param connection Write the schema at this connection to the file
  def self.write_expected_schema(connection = ActiveRecord::Base.connection)
    File.write(SCHEMA_FILE, current_schema(connection).to_yaml)
  end

  class << self
    private

    def expected_schema
      YAML.load_file(SCHEMA_FILE)
    end

    def current_schema(connection)
      connection.tables.sort.each_with_object({}) do |t, h|
        h[t] = connection.columns(t).map(&:name)
      end
    end

    def check_schema_columns(connection)
      compare_schema = current_schema(connection)

      errors = []
      expected_schema.each do |table, expected_columns|
        next if compare_schema[table] == expected_columns

        errors << <<-ERROR.gsub!(/^ +/, "")
          Schema validation failed for host #{db_connection_host(connection)}:

          Columns for table #{table} in the current schema do not match the columns listed in #{SCHEMA_FILE}

          expected:
          #{expected_columns.inspect}

          got:
          #{compare_schema[table].inspect}
        ERROR
      end
      errors.empty? ? nil : errors.join("\n")
    end

    def check_schema_tables(connection)
      current_tables  = current_schema(connection).keys - MiqPglogical::ALWAYS_EXCLUDED_TABLES
      expected_tables = expected_schema.keys - MiqPglogical::ALWAYS_EXCLUDED_TABLES

      return if current_tables == expected_tables

      diff_in_current  = current_tables - expected_tables
      diff_in_expected = expected_tables - current_tables
      if diff_in_current.empty? && diff_in_expected.empty?
        <<-ERROR.gsub!(/^ +/, "")
          Schema validation failed for host #{db_connection_host(connection)}:

          Expected schema table order does not match sorted current tables.
          Use 'rake evm:db:write_schema' to generate the new expected schema when making changes.
        ERROR
      else
        <<-ERROR.gsub!(/^ +/, "")
          Schema validation failed for host #{db_connection_host(connection)}:

          Current schema tables do not match expected

          Additional tables in current schema: #{diff_in_current}
          Missing tables in current schema: #{diff_in_expected}
        ERROR
      end
    end

    def db_connection_host(connection)
      connection.raw_connection.conninfo_hash[:host] || "localhost"
    end
  end
end
