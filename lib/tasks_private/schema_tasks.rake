namespace :db do
  desc 'Write the current schema to the schema.yml file'
  task :write_schema => :environment do
    ManageIQ::Schema::Checker.write_expected_schema
    puts "Wrote configured schema to schema.yml"
  end
end
