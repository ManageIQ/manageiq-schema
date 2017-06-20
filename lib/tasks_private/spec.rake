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
    return [] unless system(fetch_command)
    files = `git ls-tree -r --name-only #{TEST_BRANCH} db/migrate/`
    return [] unless $?.success?

    migrations = files.split.map do |path|
      filename = path.split("/")[-1]
      filename.split('_')[0]
    end

    # eliminate any non-timestamp entries
    migrations.keep_if { |timestamp| timestamp =~ /\d+/ }
  ensure
    `git branch -D #{TEST_BRANCH}`
  end

  def fetch_command
    "git fetch #{'--depth=1 ' if ENV['CI']}http://github.com/ManageIQ/manageiq.git refs/heads/#{RELEASED_BRANCH}:#{TEST_BRANCH}"
  end
end
