class AddSchemaMigrationsRan < ActiveRecord::Migration[5.0]
  def up
    create_table :schema_migrations_ran do |t|
      t.string :version
      t.datetime :created_at, :null => false
    end
  end

  def down
    drop_table :schema_migrations_ran
  end
end
