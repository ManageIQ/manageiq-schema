class MovePicturesBlobsToPictures < ActiveRecord::Migration[5.0]
  class BinaryBlob < ActiveRecord::Base
    include ActiveRecord::IdRegions
    has_many :binary_blob_parts, -> { order(:id) }, :dependent => :delete_all, :class_name => "MovePicturesBlobsToPictures::BinaryBlobPart"
    def data
      binary_blob_parts.pluck(:data).join
    end
  end
  class BinaryBlobPart < ActiveRecord::Base; end
  class Picture < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  def up
    add_column :pictures, :content, :binary
    add_column :pictures, :extension, :string
    add_column :pictures, :md5, :string

    say_with_time("Moving picture content from BinaryBlobs to the pictures table") do
      BinaryBlob.in_my_region.includes(:binary_blob_parts).where(:resource_type => "Picture").find_each do |blob|
        Picture.where(:id => blob.resource_id).update_all(:content => blob.data, :extension => blob.data_type, :md5 => blob.md5) if blob.resource_id
        blob.destroy
      end
    end
  end

  def down
    say_with_time("Moving picture content from the pictures table to BinaryBlobs") do
      Picture.in_my_region.find_each do |picture|
        size = picture.content.try(:length).to_i
        next if size.zero?

        BinaryBlob.create!(
          :data_type     => picture.extension,
          :md5           => picture.md5,
          :part_size     => size,
          :resource_id   => picture.id,
          :resource_type => "Picture",
          :size          => size,
        ).binary_blob_parts.create!(
          :data => picture.content,
          :md5  => picture.md5,
          :size => size,
        )
      end
    end

    remove_column :pictures, :content
    remove_column :pictures, :extension
    remove_column :pictures, :md5
  end
end
