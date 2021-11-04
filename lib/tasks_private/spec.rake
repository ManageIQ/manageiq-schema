desc "Run all specs"
task :spec => ["spec:non_migration", "spec:migrations", "spec:schema"]

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

  desc <<~DESC
    Generate table list for schema specs

    Generates a list of tables from the `spec/dummy/db/schema.rb` to be used in
    the `schema_dumper_spec.rb`.
  DESC
  task :table_list => "spec:migrations:complete_up" do
    File.open("spec/support/table_list.txt", "w") do |table_list|
      File.open("spec/dummy/db/schema.rb").each_line do |line|
        next unless line =~ /^\s*create_table\s+"([^"]+)"/

        table_list.puts $1
      end
    end
  end

  desc "Run all non-migration specs"
  RSpec::Core::RakeTask.new(:non_migration => :initialize) do |t|
    t.pattern = FileList["spec/**/*_spec.rb"].exclude("spec/dummy/**/*_spec.rb")
                                             .exclude("spec/migrations/**/*_spec.rb")
                                             .exclude("spec/schema/**/*_spec.rb")
  end

  desc "Run schema specs"
  RSpec::Core::RakeTask.new(:schema => [:initialize, "spec:migrations:complete_up"]) do |t|
    t.pattern = FileList["spec/schema/**/*_spec.rb"]
  end
end
