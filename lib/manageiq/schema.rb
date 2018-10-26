require "manageiq/schema/version"
require "manageiq/schema/engine"

require 'activerecord-id_regions'
require 'manageiq/password'
require 'more_core_extensions/all' # TODO: Move this into specific migrations that need it

require 'migration_helper'
require 'migration_stub_helper'

require 'reserve'
require 'reserved_shared_mixin'
require 'reserved_migration_mixin'
require 'reserved_mixin'

require 'pg/pglogical'
require 'pg/pglogical/active_record_extension'

module ManageIQ
  module Schema
    SYSTEM_TABLES = %w(ar_internal_metadata schema_migrations repl_events repl_monitor repl_nodes).freeze
  end
end
