describe "Data migrations" do
  def data_migration_files
    Spec::Support::ConstantWatcher.classes_by_file.keys.select { |file| file.include?("db/migrate") }
  end

  it "need tests" do
    Dir.glob(ManageIQ::Schema::Engine.root.join("db", "migrate", "*.rb")).each { |i| require i }

    data_migration_files.each do |data_migration_file|
      spec_file_basename = File.basename(data_migration_file).sub(".rb", "_spec.rb")
      spec_file = ManageIQ::Schema::Engine.root.join("spec", "migrations", spec_file_basename)

      expect(spec_file.file?).to eq(true), "Missing data migration spec at #{spec_file}"
    end
  end
end
