require_migration

describe ChangeHardwareMemTypes do
  migration_context :down do
    let(:hardware) { migration_stub(:Hardware).create(:memory_mb => 2_147_483_648) }

    it "caps > 2147483647" do
      expect(hardware.memory_mb).to eq(2_147_483_648)

      migrate
      hardware.reload

      expect(hardware).to have_attributes(:memory_mb => 2_147_483_647)
    end
  end
end
