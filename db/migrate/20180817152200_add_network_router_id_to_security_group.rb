class AddNetworkRouterIdToSecurityGroup < ActiveRecord::Migration[5.0]
  def change
    add_reference :security_groups, :network_router, :type => :bigint, :index => true
  end
end
