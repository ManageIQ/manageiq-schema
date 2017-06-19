require "manageiq/schema/version"
require "manageiq/schema/engine"

require 'activerecord-id_regions'
require 'gems/pending/util/miq-password'
require 'more_core_extensions/all' # TODO: Move this into specific migrations that need it

require "manageiq/schema/checker"
require 'migration_helper'
require 'migration_stub_helper'

require 'reserve'
require 'reserved_shared_mixin'
require 'reserved_migration_mixin'
require 'reserved_mixin'
