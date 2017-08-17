desc 'Check the current schema against the schema.yml file for inconsistencies'
task :check_schema => :environment do
  message = ManageIQ::Schema::Checker.check_schema
  raise message if message
  puts "The local schema is consistent with schema.yml"
end

desc 'Write the current schema to the schema.yml file'
task :write_schema => :environment do
  ManageIQ::Schema::Checker.write_expected_schema
  puts "Wrote configured schema to schema.yml"
end
