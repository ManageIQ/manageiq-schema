class RemoveVimTypesFromBinaryBlobParts < ActiveRecord::Migration[6.0]
  class BinaryBlob < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  class BinaryBlobPart < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  def up
    say_with_time("Removing VimTypes from BinaryBlobParts") do
      # Only consider BinaryBlobs which are a YAML data type, this means we are safe to
      # ENCODE the bytea type to text
      yaml_binary_blobs = BinaryBlob.in_my_region.select(:id).where(:data_type => "YAML")

      # Since binary_blob_parts#data is a binary data type we have to encode it to
      # allow REPLACE() to function, then cast it back to a binary type
      BinaryBlobPart.in_my_region
                    .where(:binary_blob_id => yaml_binary_blobs)
                    .where("ENCODE(data, 'escape') LIKE ?", "%!ruby/string:VimString%")
                    .update_all("data = REPLACE(ENCODE(data, 'escape'), '!ruby/string:VimString', '!ruby/string:String')::bytea")
    end
  end

  def down
    say_with_time("Resetting VimTypes from BinaryBlobParts") do
      yaml_binary_blobs = BinaryBlob.in_my_region.select(:id).where(:data_type => "YAML")

      BinaryBlobPart.in_my_region
                    .where(:binary_blob_id => yaml_binary_blobs)
                    .where("ENCODE(data, 'escape') LIKE ?", "%!ruby/string:String%")
                    .update_all("data = REPLACE(ENCODE(data, 'escape'), '!ruby/string:String', '!ruby/string:VimString')::bytea")
    end
  end
end
