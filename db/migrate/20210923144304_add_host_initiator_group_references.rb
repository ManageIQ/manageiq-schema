class AddHostInitiatorGroupReferences < ActiveRecord::Migration[6.0]
  def change
    add_reference :host_initiators, :host_initiator_group, :type => :bigint
    add_reference :volume_mappings, :host_initiator_group, :type => :bigint
  end
end
