namespace :db do
  desc 'Check the current schema against the schema.yml file for inconsistencies'
  task :check_schema => :environment do
    message = ManageIQ::Schema::Checker.check_schema
    raise message if message
    puts "The local schema is consistent with schema.yml"
  end
end
