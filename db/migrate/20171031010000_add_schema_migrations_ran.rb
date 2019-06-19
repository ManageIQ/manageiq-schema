class AddSchemaMigrationsRan < ActiveRecord::Migration[5.0]
  def up
    create_table :schema_migrations_ran do |t|
      t.string :version
      t.datetime :created_at, :null => false
    end

    require 'pg/pglogical'
    require 'pg/pglogical/active_record_extension'

    pglogical = ActiveRecord::Base.connection.pglogical
    if pglogical.enabled? && pglogical.replication_sets.include?('miq')
      # don't do an initial data sync for this table
      # we want the data do come in as it's replicated rather than in bulk
      pglogical.replication_set_add_table('miq', "schema_migrations_ran", false)
    end
  end

  def down
    drop_table :schema_migrations_ran
  end
end
