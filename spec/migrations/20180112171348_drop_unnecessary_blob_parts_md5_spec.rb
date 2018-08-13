require_migration

describe DropUnnecessaryBlobPartsMd5 do
  let(:binary_blob_part_stub) { migration_stub :BinaryBlobPart }

  migration_context :down do
    it "restores the md5 sum and size of all records" do
      record = binary_blob_part_stub.create!(:data => "A test string")
      # puts "ID #{record.id} BBPOID: #{binary_blob_part_stub.object_id} REGION: #{binary_blob_part_stub.my_region_number}"
$in_this_test = true

      migrate
$in_this_test = false
      expect(record.reload).to have_attributes(
        :md5  => "99ce4dbdc6db1ab876443113ae24b816",
        :size => 13,
      )
    end
  end
end
