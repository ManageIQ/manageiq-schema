namespace :spec do
  desc "Run all migration specs"
  task :migrations => %w(
    spec:initialize
    spec:migrations:down
    spec:migrations:complete_down
    spec:migrations:up
    spec:migrations:complete_up
  )

  namespace :migrations do
    desc "Run the up migration specs only"
    RSpec::Core::RakeTask.new(:up => :initialize) do |t|
      t.rspec_opts = ["--tag", "migrations:up"]
      t.pattern = FileList['spec/migrations/**/*_spec.rb'].sort
    end

    desc "Run the down migration specs only"
    RSpec::Core::RakeTask.new(:down => :initialize) do |t|
      t.rspec_opts = ["--tag", "migrations:down"]

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

    desc "Complete the up migrations to the latest"
    task :complete_up => :initialize do
      puts "** Migrating all the way up"
      run_rake_via_shell("db:migrate")
    end

    desc "Complete the down migrations to 0"
    task :complete_down => :initialize do
      puts "** Migrating all the way down"
      run_rake_via_shell("db:migrate", "VERSION" => "0")
    end

    def run_rake_via_shell(rake_command, env = {})
      env["RAILS_ENV"] = ENV["RAILS_ENV"] || "test"
      env["VERBOSE"]   = ENV["VERBOSE"] || "false"

      cmd = "bundle exec rake #{rake_command}"
      cmd << " --trace" if Rake.application.options.trace
      _pid, status = Bundler.with_original_env do
        Process.wait2(Kernel.spawn(env, cmd))
      end
      exit(status.exitstatus) if status.exitstatus != 0
    end
  end
end
