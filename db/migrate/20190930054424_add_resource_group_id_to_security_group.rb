class AddResourceGroupIdToSecurityGroup < ActiveRecord::Migration[5.1]
  def change
    add_reference :security_groups, :resource_group, :type => :bigint, :index => true
  end
end
