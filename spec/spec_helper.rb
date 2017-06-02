ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment", __FILE__)

require 'rspec/rails'

# TODO: Remove me
Rails.logger.level = 0
ActiveSupport::Deprecation.silenced = true

MiqPassword.v2_key = MiqPassword::Key.new

Dir[File.expand_path("support/**/*.rb", __dir__)].each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.extend  Spec::Support::MigrationHelper::DSL
  config.include Spec::Support::MigrationHelper, :migrations => :up
  config.include Spec::Support::MigrationIdRegionsHelper, :migrations => :up
  config.include Spec::Support::MigrationHelper, :migrations => :down
  config.include Spec::Support::MigrationIdRegionsHelper, :migrations => :down
end
