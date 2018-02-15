class AddComplianceInformationToPhysicalServers < ActiveRecord::Migration[5.0]
  def change
    add_column :physical_servers, :ems_compliance_name, :string
    add_column :physical_servers, :ems_compliance_status, :string
  end
end
