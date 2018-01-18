require_migration

describe MovePicturesBlobsToPictures do
  let(:binary_blob_stub)      { migration_stub :BinaryBlob }
  let(:binary_blob_part_stub) { migration_stub :BinaryBlobPart }
  let(:picture_stub)          { migration_stub :Picture }

  migration_context :up do
    it 'Destroys picture blobs with an invalid picture id' do
      picture = picture_stub.create!
      blob    = binary_blob_stub.create!(
        :data_type     => "png",
        :md5           => "ce114e4501d2f4e2dcea3e17b546f339",
        :part_size     => 1.megabyte,
        :resource_id   => picture.id + 42,
        :resource_type => "Picture",
        :size          => 14,
      )
      binary_blob_part_stub.create!(
        :binary_blob_id => blob.id,
        :data           => "This is a test",
        :md5            => "ce114e4501d2f4e2dcea3e17b546f339",
        :size           => 14,
      )

      migrate

      expect(picture_stub.count).to eq(1)
      expect(binary_blob_stub.count).to eq(0)
      expect(binary_blob_part_stub.count).to eq(0)
    end

    it 'Destroys picture blobs with a nil picture id' do
      blob = binary_blob_stub.create!(
        :data_type     => "png",
        :md5           => "ce114e4501d2f4e2dcea3e17b546f339",
        :part_size     => 1.megabyte,
        :resource_id   => nil,
        :resource_type => "Picture",
        :size          => 14,
      )
      binary_blob_part_stub.create!(
        :binary_blob_id => blob.id,
        :data           => "This is a test",
        :md5            => "ce114e4501d2f4e2dcea3e17b546f339",
        :size           => 14,
      )

      migrate

      expect(picture_stub.count).to eq(0)
      expect(binary_blob_stub.count).to eq(0)
      expect(binary_blob_part_stub.count).to eq(0)
    end

    it 'Moves a single-part image blob' do
      picture = picture_stub.create!
      blob    = binary_blob_stub.create!(
        :data_type     => "png",
        :md5           => "ce114e4501d2f4e2dcea3e17b546f339",
        :part_size     => 1.megabyte,
        :resource_id   => picture.id,
        :resource_type => "Picture",
        :size          => 14,
      )
      binary_blob_part_stub.create!(
        :binary_blob_id => blob.id,
        :data           => "This is a test",
        :md5            => "ce114e4501d2f4e2dcea3e17b546f339",
        :size           => 14,
      )

      migrate

      expect(picture.reload).to have_attributes(
        :content   => "This is a test",
        :extension => "png",
        :md5       => "ce114e4501d2f4e2dcea3e17b546f339",
      )
      expect(binary_blob_stub.count).to eq(0)
      expect(binary_blob_part_stub.count).to eq(0)
    end

    it 'Moves a multi-part image blob' do
      picture = picture_stub.create!
      blob    = binary_blob_stub.create!(
        :data_type     => "png",
        :md5           => "c65dfd70c813cc2d519fcad28ebaee6f",
        :part_size     => 1.megabyte,
        :resource_id   => picture.id,
        :resource_type => "Picture",
        :size          => 32,
      )
      binary_blob_part_stub.create!(
        :binary_blob_id => blob.id,
        :data           => "This is a multi",
        :md5            => "94efec8abb26d346812c3a0a8dc98306",
        :size           => 15,
      )
      binary_blob_part_stub.create!(
        :binary_blob_id => blob.id,
        :data           => "-part test stri",
        :md5            => "10b11598b01f3b02d767e238be22e78b",
        :size           => 15,
      )
      binary_blob_part_stub.create!(
        :binary_blob_id => blob.id,
        :data           => "ng",
        :md5            => "66e10e9ff65ef479654dde3968d3440d",
        :size           => 2,
      )

      migrate

      expect(picture.reload).to have_attributes(
        :content   => "This is a multi-part test string",
        :extension => "png",
        :md5       => "c65dfd70c813cc2d519fcad28ebaee6f",
      )
      expect(binary_blob_stub.count).to eq(0)
      expect(binary_blob_part_stub.count).to eq(0)
    end
  end

  migration_context :down do
    it 'Moves back to a single binary blob' do
      picture = picture_stub.create!(
        :content   => "This is a test",
        :extension => "png",
        :md5       => "ce114e4501d2f4e2dcea3e17b546f339",
      )

      migrate

      expect(binary_blob_stub.count).to eq(1)
      expect(binary_blob_part_stub.count).to eq(1)
      expect(binary_blob_stub.first).to have_attributes(
        :data_type     => "png",
        :md5           => "ce114e4501d2f4e2dcea3e17b546f339",
        :part_size     => 14,
        :resource_id   => picture.id,
        :resource_type => "Picture",
        :size          => 14,
      )
      expect(binary_blob_part_stub.first).to have_attributes(
        :binary_blob_id => binary_blob_stub.first.id,
        :data           => "This is a test",
        :md5            => "ce114e4501d2f4e2dcea3e17b546f339",
        :size           => 14,
      )
    end
  end
end
