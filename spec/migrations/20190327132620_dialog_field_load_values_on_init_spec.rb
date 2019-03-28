require_migration

describe DialogFieldLoadValuesOnInit do
  let(:dialog_field_stub) { migration_stub(:DialogField) }

  migration_context :up do
    before do
      [true, false, nil].each do |show|
        [true, false, nil].each do |load|
          dialog_field_stub.create!(:show_refresh_button => show, :load_values_on_init => load)
        end
      end

      migrate
    end

    it "updates load_values_on_init" do
      expect(dialog_field_stub.pluck(:load_values_on_init)).to eq([true, false, nil, true, true, true, true, true, true])
    end
  end
end
