require_migration

describe DropUnnecessaryBlobPartsMd5 do
  let(:binary_blob_part_stub) { migration_stub :BinaryBlobPart }

  migration_context :down do
    it "restores the md5 sum and size of all records" do
      record = binary_blob_part_stub.create!(:data => "A test string")

      migrate

      expect(record.reload).to have_attributes(
        :md5  => "99ce4dbdc6db1ab876443113ae24b816",
        :size => 13,
      )
    end
  end
end
