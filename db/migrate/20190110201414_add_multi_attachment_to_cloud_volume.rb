class AddMultiAttachmentToCloudVolume < ActiveRecord::Migration[5.0]
  def change
    add_column :cloud_volumes, :multi_attachment, :boolean
  end
end
