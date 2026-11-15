class AddSigningFieldsToBinaryBlobsAndMiqDatabase < ActiveRecord::Migration[8.0]
  def change
    add_column :binary_blobs, :content_type, :string
    add_column :binary_blobs, :path, :string
    add_index  :binary_blobs, :path, :unique => true

    add_column :miq_databases, :signing_secret_token, :string
  end
end
