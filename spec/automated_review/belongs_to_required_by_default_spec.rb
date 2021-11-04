describe "belongs_to_required_by_default" do
  it "should be the default value of true", :skip => "Skipped until all migrations specs are changed to work with the default value" do
    # NOTE: Once all migrations are changed, we can remove this test. It is here to act as a reminder.
    expect(Rails.application.config.active_record.belongs_to_required_by_default).to be true
  end
end
