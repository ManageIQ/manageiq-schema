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

  def write_released_migrations
    puts "** Writing #{released_migrations_file}..."
    File.write(released_migrations_file, released_migrations.join("\n"))
    puts "** Writing #{released_migrations_file}...Complete"
  rescue
    STDERR.puts "** ERROR: Unable to write #{released_migrations_file}"
    raise
  end

  private

  def data_dir
    ManageIQ::Schema::Engine.root.join("spec/replication/util/data")
  end

  def clone_dir
    data_dir.join("manageiq")
  end

  def released_migrations_file
    data_dir.join("released_migrations")
  end

  def released_migrations
    raise "Unable to update repo" unless update_repo

    files, success = Dir.chdir(clone_dir) do
      [`git ls-tree -r --name-only #{RELEASED_BRANCH} db/migrate/`, $?.success?]
    end
    raise "Unable to list migration files" unless success

    migrations = files.split.map do |path|
      filename = path.split("/")[-1]
      filename.split('_')[0]
    end

    # eliminate any non-timestamp entries
    migrations.keep_if { |timestamp| timestamp =~ /\d+/ }.sort
  end

  def update_repo
    unless Dir.exist?(clone_dir)
      return false unless system("git clone --bare --depth=1 --branch=#{RELEASED_BRANCH} http://github.com/ManageIQ/manageiq.git #{clone_dir}")
    end
    system("git fetch --depth=1 origin #{RELEASED_BRANCH}:#{RELEASED_BRANCH}", :chdir => clone_dir)
  end
end
