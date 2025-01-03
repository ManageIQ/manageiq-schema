def require_migration
  require migration_path
end

def migration_path
  spec_name = caller_locations.detect {|loc| loc.path.end_with?("_spec.rb")}.path
  spec_name.sub("spec/migrations", "db/migrate").sub("_spec.rb", ".rb")
end
