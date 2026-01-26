require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe MoveMiqServersHasVixDiskLibToCapabilities do
  let(:miq_server_stub) { migration_stub(:MiqServer) }

  migration_context :up do
    let(:has_vix_disk_lib) { nil }
    let!(:miq_server) { miq_server_stub.create!(:has_vix_disk_lib => has_vix_disk_lib) }

    context "with has_vix_disk_lib=true" do
      let(:has_vix_disk_lib) { true }

      it "sets capabilities.vix_disk_lib" do
        migrate

        expect(miq_server.reload).to have_attributes(:capabilities => {"vix_disk_lib" => true})
      end
    end

    context "with has_vix_disk_lib=false" do
      let(:has_vix_disk_lib) { false }

      it "sets capabilities.vix_disk_lib" do
        migrate

        expect(miq_server.reload).to have_attributes(:capabilities => {"vix_disk_lib" => false})
      end
    end
  end

  migration_context :down do
    it "sets has_vix_disk_lib" do
      miq_server = miq_server_stub.create!(:capabilities => {"vix_disk_lib" => true})

      migrate

      expect(miq_server.reload).to have_attributes(:has_vix_disk_lib => true)
    end
  end
end
