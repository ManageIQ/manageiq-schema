class AddApiVersionAndDomainIdAndSecurityProtocolAndOpenstackRegionToFileDepot < ActiveRecord::Migration[5.0]
  def change
    add_column :file_depots, :keystone_api_version, :string
    add_column :file_depots, :v3_domain_ident,      :string
    add_column :file_depots, :security_protocol,    :string
    add_column :file_depots, :openstack_region,     :string
  end
end
