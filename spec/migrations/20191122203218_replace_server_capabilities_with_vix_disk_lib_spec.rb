require_migration

describe ReplaceServerCapabilitiesWithVixDiskLib do
  let(:miq_server_stub) { migration_stub :MiqServer }

  migration_context :up do
    it "migrates from capabilities to vix disk column" do
      cap_true  = miq_server_stub.create(:capabilities => {:vixDisk => true})
      cap_false = miq_server_stub.create(:capabilities => {:vixDisk => false})
      cap_empty = miq_server_stub.create(:capabilities => {})
      cap_nil   = miq_server_stub.create(:capabilities => nil)

      migrate

      expect(cap_true.reload.has_vix_disk_lib).to be_truthy
      expect(cap_false.reload.has_vix_disk_lib).to be_falsey
      expect(cap_empty.reload.has_vix_disk_lib).to be_falsey
      expect(cap_nil.reload.has_vix_disk_lib).to be_falsey
    end
  end

  migration_context :down do
    it "migrates from vix disk column to capabilities" do
      vix_true  = miq_server_stub.create(:has_vix_disk_lib => true)
      vix_false = miq_server_stub.create(:has_vix_disk_lib => false)
      vix_nil   = miq_server_stub.create(:has_vix_disk_lib => nil)

      migrate

      expect(vix_true.reload.capabilities[:vixDisk]).to be_truthy
      expect(vix_false.reload.capabilities[:vixDisk]).to be_falsey
      expect(vix_nil.reload.capabilities[:vixDisk]).to be_falsey
    end
  end
end
