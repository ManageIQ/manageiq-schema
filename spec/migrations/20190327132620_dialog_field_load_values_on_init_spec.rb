require_migration

describe DialogFieldLoadValuesOnInit do
  let(:dialog_field_stub) { migration_stub(:DialogField) }

  migration_context :up do
    before do
      [true, false, nil].each do |show_button|
        [true, false, nil].each do |load_values|
          dialog_field_stub.create!(:show_refresh_button => show_button, :load_values_on_init => load_values)
        end
      end

      migrate
    end

    it "updates load_values_on_init" do
      expect(dialog_field_stub.sort_by(:id).pluck(:load_values_on_init)).to eq([
        true, false, nil, # show_button was true
        true, true, true,
        true, true, true,
      ])
    end
  end
end
