require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults Rails::VERSION::STRING.to_f

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # HACK: Temporary override of the default setting until we can update the
    # migration specs to honor it.
    config.active_record.belongs_to_required_by_default = false

    # Note, you can't pass kwargs :coder => YAML to serialize until rails 7.1 as it was a positional
    # argument previously.  To avoid a case statement in all usages of serialize, we're defaulting
    # all serialized columns to YAML for rails 7.1+ here. Ideally, we would use JSON if we find we can
    # use a simpler datatype. See: https://github.com/rails/rails/pull/47463
    config.active_record.default_column_serializer = YAML if Rails.version >= "7.1"
    config.active_record.use_yaml_unsafe_load = true
  end
end
