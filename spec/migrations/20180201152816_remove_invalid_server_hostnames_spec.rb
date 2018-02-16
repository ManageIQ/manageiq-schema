require_migration

describe RemoveInvalidServerHostnames do
  let(:miq_server_stub) { migration_stub :MiqServer }

  migration_context :up do
    it "nil is unchanged" do
      miq_server_stub.create!

      migrate

      expect(miq_server_stub.pluck(:hostname)).to eq([nil])
    end

    it "valid is unchanged" do
      miq_server_stub.create!(:hostname => "abc-def.example.com")

      migrate

      expect(miq_server_stub.pluck(:hostname)).to eq(["abc-def.example.com"])
    end

    it "invalid is now nil" do
      miq_server_stub.create!(:hostname => "invalid_hostname.example.com")

      migrate

      expect(miq_server_stub.pluck(:hostname)).to eq([nil])
    end
  end
end
