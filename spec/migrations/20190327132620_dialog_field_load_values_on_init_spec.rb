require_migration

describe DialogFieldLoadValuesOnInit do
  let(:dialog_field_stub) { migration_stub(:DialogField) }

  migration_context :up do
    let(:show_button) { nil }

    before do
      [true, false, nil].each do |load_values|
        dialog_field_stub.create!(:show_refresh_button => show_button, :load_values_on_init => load_values)
      end

      migrate
    end

    context "when show_refresh_button is true" do
      let(:show_button) { true }

      it "doesnt update load_values_on_init" do
        expect(dialog_field_stub.order(:id).pluck(:load_values_on_init)).to eq([true, false, nil])
      end
    end

    context "when show_refresh_button is false" do
      let(:show_button) { false }

      it "updates load_values_on_init to true" do
        expect(dialog_field_stub.order(:id).pluck(:load_values_on_init)).to eq([true, true, true])
      end
    end

    context "when show_refresh_button is nil" do
      let(:show_button) { nil }

      it "updates load_values_on_init to true" do
        expect(dialog_field_stub.order(:id).pluck(:load_values_on_init)).to eq([true, true, true])
      end
    end
  end
end
