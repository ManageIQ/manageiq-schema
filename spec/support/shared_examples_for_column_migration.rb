# it tests data migration for one column
# Example:
# include_examples "column migration", :type, :ExtManagementSystem, ["Old Data Field", "New Data Field"]
shared_examples_for "column migration" do |column, klass, data_to_convert|
  let(:stub)           { migration_stub(klass) }
  let(:old_data_field) { data_to_convert.first }
  let(:new_data_field) { data_to_convert.second }

  it "migrates column #{column} of #{klass}" do
    rec = stub.create!(column => old_data_field)

    migrate

    column_value = rec.reload.send(column)
    expect(column_value).to eq(new_data_field)
  end
end

# it tests one column is added
# Example:
# it_behaves_like "column addition", :status, :MiddlewareDomain
shared_examples_for 'column addition' do |column, klass|
  let(:stub) { migration_stub(klass) }

  it "adds column #{column} to #{klass}" do
    rec = stub.create!

    migrate

    rec.reload
    expect(rec.reload.respond_to?(column)).to eq true
  end
end

# it tests one column is deleted
# Example:
# it_behaves_like "column deletion", :status, :MiddlewareDomain
shared_examples_for 'column deletion' do |column, klass|
  let(:stub) { migration_stub(klass) }

  it "adds column #{column} to #{klass}" do
    rec = stub.create!

    migrate

    rec.reload
    expect(rec.reload.respond_to?(column)).to eq false
  end
end
