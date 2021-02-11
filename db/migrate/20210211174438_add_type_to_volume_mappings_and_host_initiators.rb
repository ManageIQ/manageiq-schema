class AddTypeToVolumeMappingsAndHostInitiators < ActiveRecord::Migration[6.0]
  def change
    add_column :volume_mappings, :type, :string
    add_column :host_initiators, :type, :string
  end
end
