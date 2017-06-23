namespace :spec do
  task :initialize do
    ENV["VERBOSE"]   ||= "false"
    ENV["RAILS_ENV"] ||= "test"
    Rails.env = ENV["RAILS_ENV"] if defined?(Rails)
  end

  task :setup_released_migrations do
    SetupReleasedMigrations.new.write_released_migrations
  end

  desc "Prepare all specs"
  task :setup => [:initialize, "db:drop", "db:create", "db:migrate", :setup_released_migrations]
end

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec => "spec:initialize") do |t|
  t.pattern = FileList["spec/**/*_spec.rb"].exclude("spec/migrations/**/*_spec.rb")
end

class SetupReleasedMigrations
  RELEASED_BRANCH = "fine".freeze
  TEST_BRANCH = "setup_released_migrations_branch".freeze

  def write_released_migrations
    file_contents = released_migrations.sort.join("\n")
    File.write(ManageIQ::Schema::Engine.root.join("spec/replication/util/data/released_migrations"), file_contents)
  end

  private

  def released_migrations
    require 'net/http'
    json = Net::HTTP.get(URI("https://api.github.com/repos/ManageIQ/manageiq/contents/db/migrate?ref=#{RELEASED_BRANCH}"))

    migrations = JSON.parse(json).map do |h|
      filename = h["path"].split("/")[-1]
      filename.split('_')[0]
    end.sort

    # eliminate any non-timestamp entries
    migrations.keep_if { |timestamp| timestamp =~ /\d+/ }
  end
end
