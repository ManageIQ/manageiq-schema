class AddCloudSubnetIdToSecurityGroup < ActiveRecord::Migration[5.0]
  def change
    add_reference :security_groups, :cloud_subnet, :type => :bigint, :index => true
  end
end
