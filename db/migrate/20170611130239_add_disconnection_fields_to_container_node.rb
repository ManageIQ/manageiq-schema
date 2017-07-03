class AddDisconnectionFieldsToContainerNode < ActiveRecord::Migration[5.0]
  def change
    add_column :container_nodes, :old_ems_id, :bigint
    add_column :container_nodes, :deleted_on, :datetime
  end
end
