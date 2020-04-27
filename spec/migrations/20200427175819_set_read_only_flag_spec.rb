require_migration

describe SetReadOnlyFlag do
  let(:dialog) { migration_stub(:Dialog) }

  migration_context :up do
    it "sets the flag" do
      dialog1 = dialog.create(:label => "anything else")
      dialog2 = dialog.create(:label => 'Transform VM')

      migrate

      expect(dialog1.reload.system).to be(false)
      expect(dialog2.reload.system).to be(true)
    end
  end
end
