class DropUnnecessaryBlobPartsMd5 < ActiveRecord::Migration[5.0]
  class BinaryBlobPart < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  def up
    remove_column :binary_blob_parts, :md5
    remove_column :binary_blob_parts, :size
  end

  def down
    add_column :binary_blob_parts, :md5,  :string
    add_column :binary_blob_parts, :size, :decimal, :precision => 20, :scale => 0

    say_with_time("Calculating md5 and size of all BinaryBlobParts") do
      require 'digest'
      BinaryBlobPart.in_my_region.find_each do |part|
        part.update_attributes(:md5 => Digest::MD5.hexdigest(part.data), :size => part.data.bytesize)
      end
    end
  end
end
