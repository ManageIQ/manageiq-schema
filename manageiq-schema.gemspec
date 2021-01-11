# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'manageiq/schema/version'

Gem::Specification.new do |spec|
  spec.name          = "manageiq-schema"
  spec.version       = ManageIQ::Schema::VERSION
  spec.authors       = ["ManageIQ Authors"]

  spec.summary       = "SQL Schema and migrations for ManageIQ."
  spec.description   = "SQL Schema and migrations for ManageIQ."
  spec.homepage      = "https://github.com/ManageIQ/manageiq-schema"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ancestry"
  spec.add_dependency "activerecord-id_regions", "~> 0.3.0"
  spec.add_dependency "linux_admin",             "~> 2.0"
  spec.add_dependency "manageiq-password",       "~> 0.3"
  spec.add_dependency "more_core_extensions",    ">= 3.5", "< 5"
  spec.add_dependency "pg"
  spec.add_dependency "pg-pglogical",            "~> 2.1.1"
  spec.add_dependency "rails",                   "~>6.0.0"

  spec.add_development_dependency "manageiq-style"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "simplecov"
end
