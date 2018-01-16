require_migration

describe DropUnnecessaryBlobPartsMd5 do
  let(:binary_blob_part_stub) { migration_stub :BinaryBlobPart }

  migration_context :down do
    it "restores the md5 sum and size of all records" do
      binary_blob_part_stub.create!(:data => "A test string")

      migrate

      expect(binary_blob_part_stub.first).to have_attributes(
        :md5  => "99ce4dbdc6db1ab876443113ae24b816",
        :size => 13,
      )
    end
  end
end
