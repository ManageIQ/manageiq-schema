class AddWorkflowToResourceAction < ActiveRecord::Migration[6.1]
  def change
    add_reference :resource_actions, :workflow
    add_column    :resource_actions, :type, :string
    add_index     :resource_actions, :type
  end
end
