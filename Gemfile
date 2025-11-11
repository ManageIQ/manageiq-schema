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

gem "rails", "~>7.2.3"

# security fixes for indirect dependencies
gem "rack", ">=2.2.20" # CVE-2025-61919 https://github.com/advisories/GHSA-6xw4-3v39-52mm
gem "thor", ">= 1.4.0" # CVE-2025-54314 https://github.com/advisories/GHSA-mqcp-p2hv-vw6x (railties)
