class CreateContainerIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index :containers, :container_group_id
    add_index :containers, :container_image_id
    add_index :containers, :ems_id
    add_index :container_images, :ems_id
  end
end
