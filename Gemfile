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

# rubocop:disable Lint/DuplicateBranch, Style/IdenticalConditionalBranches
minimum_version =
  case ENV.fetch('TEST_RAILS_VERSION', nil)
  when "8.0"
    ["~>8.0.5", ">=8.0.5.1"]
  else
    ["~>8.0.5", ">=8.0.5.1"]
  end
# rubocop:enable Lint/DuplicateBranch, Style/IdenticalConditionalBranches

gem "rails", *minimum_version

# security fixes for indirect dependencies
gem "net-imap",         ">= 0.6.4.1" # CVE-2026-47242 https://github.com/ruby/net-imap/security/advisories/GHSA-46q3-7gv7-qmgg
gem "rack",             ">= 2.2.23"  # Numerous CVEs
gem "thor",             ">= 1.4.0"   # CVE-2025-54314 https://github.com/advisories/GHSA-mqcp-p2hv-vw6x (via railties)
gem "websocket-driver", ">= 0.8.2"   # CVE-2026-61666 https://github.com/advisories/GHSA-2x63-gw47-w4mm (via actioncable)
