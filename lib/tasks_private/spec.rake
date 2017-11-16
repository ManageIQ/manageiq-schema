namespace :spec do
  task :initialize do
    ENV["VERBOSE"]   ||= "false"
    ENV["RAILS_ENV"] ||= "test"
    Rails.env = ENV["RAILS_ENV"] if defined?(Rails)
  end

  task :setup_region do
    ENV["REGION"] ||= (rand(99) + 1).to_s # Ensure we have a random, non-0, region
    puts "** Creating database with REGION #{ENV["REGION"]}"
  end

  task :setup_db => [:setup_region, "db:drop", "db:create", "db:migrate"]

  desc "Prepare all specs"
  task :setup => [:initialize, :setup_db]

  desc "Run all non-migration specs"
  RSpec::Core::RakeTask.new(:non_migration => :initialize) do |t|
    t.pattern = FileList["spec/**/*_spec.rb"].exclude("spec/migrations/**/*_spec.rb")
  end
end
