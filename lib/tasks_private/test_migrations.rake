if defined?(RSpec) && defined?(RSpec::Core::RakeTask)
namespace :test do
  desc "Run all migration specs"
  task :migrations => %w(
    test:initialize
    test:migrations:down
    test:migrations:complete_down
    test:migrations:up
    test:migrations:complete_up
  )

  namespace :migrations do
    desc "Setup environment for migration specs"
    task :setup => :setup_db

    desc "Run the up migration specs only"
    RSpec::Core::RakeTask.new(:up => :initialize) do |t|
      rspec_opts  = ["--tag", "migrations:up"]
      rspec_opts += ["--options", File.expand_path("../../.rspec_ci", __dir__)] if ENV['CI']
      t.rspec_opts = rspec_opts

      t.pattern = FileList['spec/migrations/**/*_spec.rb'].sort
    end

    desc "Run the down migration specs only"
    RSpec::Core::RakeTask.new(:down => :initialize) do |t|
      rspec_opts  = ["--tag", "migrations:down"]
      rspec_opts += ["--options", File.expand_path("../../.rspec_ci", __dir__)] if ENV['CI']
      t.rspec_opts = rspec_opts

      # NOTE: Since the upgrade to RSpec 2.12, pattern is automatically sorted
      #       under the covers, so the .reverse here is not honored.  There is
      #       currently no way to force the ordering, so the migrations will
      #       just have to run in a sawtooth order.
      #
      #       See: https://github.com/rspec/rspec-core/issues/881
      #            https://github.com/rspec/rspec-core/pull/660
      #            https://github.com/rspec/rspec-core/blob/v2.12.0/lib/rspec/core/rake_task.rb#L164
      t.pattern = FileList['spec/migrations/**/*_spec.rb'].sort.reverse
    end

    task :complete_up => :initialize do
      puts "** Migrating all the way up"
      run_rake_via_shell("db:migrate", "VERBOSE" => ENV["VERBOSE"] || "false")
    end

    task :complete_down => :initialize do
      puts "** Migrating all the way down"
      run_rake_via_shell("db:migrate", "VERSION" => "0", "VERBOSE" => ENV["VERBOSE"] || "false")
    end

    def run_rake_via_shell(rake_command, env = {})
      cmd = "bundle exec rake #{rake_command}"
      cmd << " --trace" if Rake.application.options.trace
      _pid, status = Process.wait2(Kernel.spawn(env, cmd, :chdir => Rails.root))
      exit(status.exitstatus) if status.exitstatus != 0
    end
  end
end
end # ifdef
