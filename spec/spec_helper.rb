if ENV['CI']
  require 'simplecov'
  SimpleCov.start
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment", __FILE__)

require 'rspec/rails'

require "manageiq/password/rspec_matchers"
ManageIQ::Password.key_root = File.expand_path("dummy/certs", __dir__)

Dir[File.expand_path("support/**/*.rb", __dir__)].each { |f| require f }
Dir[Rails.root.join('spec', 'shared', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.extend  Spec::Support::MigrationHelper::DSL
  config.include Spec::Support::MigrationHelper, :migrations => :up
  config.include Spec::Support::MigrationIdRegionsHelper, :migrations => :up
  config.include Spec::Support::MigrationHelper, :migrations => :down
  config.include Spec::Support::MigrationIdRegionsHelper, :migrations => :down
end

require "rails"
puts
puts "\e[93mUsing Rails #{Rails.version}\e[0m"
