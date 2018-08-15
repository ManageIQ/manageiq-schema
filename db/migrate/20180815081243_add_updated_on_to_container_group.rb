class AddUpdatedOnToContainerGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :container_groups, :updated_on, :datetime
  end
end
