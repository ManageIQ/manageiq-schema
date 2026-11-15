class AddOwnershipToContainerProjects < ActiveRecord::Migration[8.0]
  def change
    add_reference :container_projects, :evm_owner, :type => :bigint, :index => true
    add_reference :container_projects, :miq_group, :type => :bigint, :index => true
    add_reference :container_projects, :tenant,    :type => :bigint, :index => true
  end
end
