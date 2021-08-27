class AddTimestampsToBinaryBlobs < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :binary_blobs, :null => false, :default => -> { 'NOW()' }
  end
end
