class RemoveEmsRefFromContainerImage < ActiveRecord::Migration[5.0]
  def change
    remove_column :container_images, :ems_ref, :string
  end
end
