source "https://rubygems.org"

# Declare your gem's dependencies in manageiq-schema.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

plugin "bundler-inject", "~> 1.1"
require File.join(Bundler::Plugin.index.load_paths("bundler-inject")[0], "bundler-inject") rescue nil

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

minimum_version =
  case ENV.fetch('TEST_RAILS_VERSION', nil)
  when "7.0"
    "~>7.0.8"
  else
    # Default local bundling to use this version for generating migrations
    "~>6.1.4"
  end
gem "rails", minimum_version
