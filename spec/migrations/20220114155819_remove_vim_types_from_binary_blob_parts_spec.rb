require_migration

describe RemoveVimTypesFromBinaryBlobParts do
  let(:binary_blob_stub)      { migration_stub(:BinaryBlob) }
  let(:binary_blob_part_stub) { migration_stub(:BinaryBlobPart) }

  migration_context :up do
    it "removes VimStrings from BinaryBlobParts" do
      binary_blob      = binary_blob_stub.create(:data_type => "YAML")
      binary_blob_part = binary_blob_part_stub.create(
        :data           => "---\n:ticket: !ruby/string:VimString\n  str: MY_TICKET\n  xsiType: :SOAP::SOAPString\n  vimType:\n:remote_url: vmrc://clone:MY_TICKET@vsphere.local:443/?moid=vm-1234\n:proto: remote\n",
        :binary_blob_id => binary_blob.id
      )

      migrate

      # ensure the string doesn't include VimString
      expect(binary_blob_part.reload.data).not_to include("VimString")

      # ensure the data loads as valid YAML
      require "yaml"
      expect(YAML.load(binary_blob_part.data)).to include(
        :ticket => "MY_TICKET",
        :proto  => "remote"
      )
    end

    it "doesn't impact other BinaryBlobParts" do
      binary_blob      = binary_blob_stub.create(:data_type => "YAML")
      binary_blob_part = binary_blob_part_stub.create(
        :data           => "---\n:ticket: MY_TICKET\n",
        :binary_blob_id => binary_blob.id
      )

      migrate

      require "yaml"
      expect(YAML.load(binary_blob_part.data)).to include(:ticket => "MY_TICKET")
    end
  end

  migration_context :down do
    it "resets ruby/string:String back to VimString" do
      binary_blob      = binary_blob_stub.create(:data_type => "YAML")
      binary_blob_part = binary_blob_part_stub.create(
        :data           => "---\n:ticket: !ruby/string:String\n  str: MY_TICKET\n  xsiType: :SOAP::SOAPString\n  vimType:\n:remote_url: vmrc://clone:MY_TICKET@vsphere.local:443/?moid=vm-1234\n:proto: remote\n",
        :binary_blob_id => binary_blob.id
      )

      migrate

      expect(binary_blob_part.reload.data).to include("ruby/string:VimString")
    end

    it "doesn't impact other BinaryBlobParts" do
      binary_blob      = binary_blob_stub.create(:data_type => "YAML")
      binary_blob_part = binary_blob_part_stub.create(
        :data           => "---\n:ticket: MY_TICKET\n",
        :binary_blob_id => binary_blob.id
      )

      migrate

      require "yaml"
      expect(YAML.load(binary_blob_part.data)).to include(:ticket => "MY_TICKET")
    end
  end
end
