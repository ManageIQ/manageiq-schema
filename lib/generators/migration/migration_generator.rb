require 'rails/generators/active_record/migration/migration_generator'

# Overwrites the default `ActiveRecord::Generators::MigrationGenerator` to
# include our own spec file for each migration generated.
#
module ManageIQ::Schema
  class MigrationGenerator < ActiveRecord::Generators::MigrationGenerator
    # Using both `source_root` (standard) and `source_paths` here so that we
    # can default to the rails sources for the `migration.rb` template, but
    # then use our own for the `migration_spec.rb` file.
    source_root ActiveRecord::Generators::MigrationGenerator.source_root
    source_paths << File.expand_path('templates', __dir__)

    # Overwrite the defaulted generated .namespace method so that this class is
    # found as the `migration` class.
    #
    # Some Thor/Rails magic happeninghere ... but basically it allows this to
    # overwrite and work properly
    #
    def self.namespace(name = nil)
      return super if name

      "migration"
    end

    def self.miq_schema_root
      ManageIQ::Schema::Engine.root
    end

    # Overwrites the default method to do the original code, but then also
    # generate the spec file.
    def create_migration_file
      super

      migration_template("migration_spec.rb", File.join(spec_dir, "#{file_name}_spec.rb"))
    end

    private

    def db_migrate_path
      self.class.miq_schema_root.join("db", "migrate")
    end

    def spec_dir
      self.class.miq_schema_root.join("spec", "migrations")
    end

    def spec_class_name
      migration_class_name.sub(/Spec$/, "")
    end
  end
end
