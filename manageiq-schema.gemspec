$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "manageiq/schema/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "manageiq-schema"
  s.version     = ManageIQ::Schema::VERSION
  s.authors     = ["ManageIQ Developers"]
  s.homepage    = "https://github.com/ManageIQ/manageiq-schema"
  s.summary     = "SQL Schema and migrations for ManageIQ"
  s.description = "SQL Schema and migrations for ManageIQ"
  s.licenses    = ["Apache-2.0"]

  s.files = Dir["{db,lib}/**/*", "LICENSE.txt", "Rakefile", "README.md"]

  s.add_dependency "activerecord-id_regions"
  s.add_dependency "more_core_extensions"
  s.add_dependency "pg", "~> 0.18.2"
  s.add_dependency "rails", "~> 5.0.2"
  s.add_dependency "pg-pglogical", "~> 2.1.1"

  s.add_dependency "manageiq-gems-pending"  # This is just for MiqPassword for now

  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "codeclimate-test-reporter", "~> 1.0.0"
  s.add_development_dependency "simplecov"
end
