class AddNetworkRouterIdToFloatingIp < ActiveRecord::Migration[5.0]
  def change
    add_reference(:floating_ips, :network_router, :type => :bigint, :index => true)
  end
end
