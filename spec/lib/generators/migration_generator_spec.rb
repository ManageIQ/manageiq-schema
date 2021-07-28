require 'spec_helper'
require 'rails/generators/test_case'
require 'generators/migration/migration_generator'

describe ManageIQ::Schema::MigrationGenerator do
  include Rails::Generators::Testing::Behaviour
  include Rails::Generators::Testing::SetupAndTeardown
  include Rails::Generators::Testing::Assertions
  include FileUtils

  tests       ManageIQ::Schema::MigrationGenerator
  destination Rails.root.join('tmp/generators')

  before do
    prepare_destination
    allow(described_class).to receive(:miq_schema_root).and_return(destination_root)
  end

  let(:migration_name)     { "my_test_migration" }
  let(:migration_path)     { File.join("db", "migrate", migration_name) }
  let(:migration_filename) { migration_file_name(migration_path) }
  let(:spec_path)          { File.join("spec", "migrations", migration_name) }
  let(:spec_filename)      { migration_filename.sub(/db\/migrate/, "spec/migrations").sub(".rb", "_spec.rb") }

  it "runs the generator without errors" do
    expect { run_generator [migration_name] }.not_to raise_error
  end

  it "creates both a migration file and migration spec" do
    run_generator [migration_name]

    expect(migration_filename).to_not be_nil
    expect(spec_filename).to_not      be_nil
    expect(File.exist?(migration_filename)).to be_truthy
    expect(File.exist?(spec_filename)).to      be_truthy
  end

  it "uses content from rails for for migration" do
    run_generator [migration_name]

    content = File.read(migration_filename)
    expect(content).to include("class MyTestMigration < ActiveRecord::Migration")
    expect(content).to include("def change")
  end

  it "uses content from manageiq-scheme for for spec" do
    run_generator [migration_name]

    content = File.read(spec_filename)
    expect(content).to include("describe MyTestMigration")
    expect(content).to include("  # let(:my_model_stub) { migration_stub(:MyModel) }")
    expect(content).to include("    # Example").exactly(4).times
    expect(content).to include("    #   my_model_stub.create!(attributes)").twice
  end
end
