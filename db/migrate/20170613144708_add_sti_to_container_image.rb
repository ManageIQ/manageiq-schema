class AddStiToContainerImage < ActiveRecord::Migration[5.0]
  def change
    add_column :container_images, :type, :string
    add_column :container_images, :ems_ref, :string
  end
end
