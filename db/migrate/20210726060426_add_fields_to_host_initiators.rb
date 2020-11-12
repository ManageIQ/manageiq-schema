class AddFieldsToHostInitiators < ActiveRecord::Migration[6.0]
  def change
    add_column :host_initiators, :status, :string
    add_column :host_initiators, :host_cluster_name, :string
  end
end
