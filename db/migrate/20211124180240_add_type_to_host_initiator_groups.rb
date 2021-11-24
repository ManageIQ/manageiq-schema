class AddTypeToHostInitiatorGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :host_initiator_groups, :type, :string
  end
end
