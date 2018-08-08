describe "Data migrations" do
  KNOWN_MISSING_DATA_MIGRATION_SPEC_FILES = [
    "20151021174044_add_tenant_default_group_spec.rb",
    "20160317041206_add_maintenance_to_host_spec.rb",
    "20160428215808_add_filters_to_entitlements_spec.rb",
    "20160713130940_remove_type_template_and_vms_filters_from_miq_search_spec.rb",
    "20170419154137_remove_deleted_migration_timestamps_spec.rb",
    "20171011180000_move_openstack_refresher_settings_spec.rb"
  ].freeze

  def data_migration_files
    Spec::Support::ConstantWatcher.classes_by_file.keys.select { |file| file.include?("db/migrate") }
  end

  it "need tests" do
    Dir.glob(ManageIQ::Schema::Engine.root.join("db", "migrate", "*.rb")).each { |i| require i }

    data_migration_files.each do |data_migration_file|
      spec_file_basename = File.basename(data_migration_file).sub(".rb", "_spec.rb")
      spec_file = ManageIQ::Schema::Engine.root.join("spec", "migrations", spec_file_basename)

      if spec_file_basename.in?(KNOWN_MISSING_DATA_MIGRATION_SPEC_FILES)
        expect(spec_file.file?).to eq(false), "Thanks for adding a test!! Please remove #{spec_file_basename} from KNOWN_MISSING_DATA_MIGRATION_SPEC_FILES in #{__FILE__}"
      else
        expect(spec_file.file?).to eq(true), "Missing data migration spec at #{spec_file}"
      end
    end
  end
end
