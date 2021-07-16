require_migration

RSpec.describe SetVmwareInfraVerifySslNone do
  let(:ems_stub)      { migration_stub(:ExtManagementSystem) }
  let(:endpoint_stub) { migration_stub(:Endpoint) }

  migration_context :up do
    it "sets existing records verify_peer to none" do
      vmware_infra     = ems_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager")
      default_endpoint = endpoint_stub.create!(:role => "default", :resource_type => "ExtManagementSystem", :resource_id => vmware_infra.id, :verify_peer => 1)

      migrate

      expect(default_endpoint.reload).to have_attributes(:verify_peer => 0)
    end
  end

  migration_context :down do
    it "set verify_peer to peer" do
      vmware_infra     = ems_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager")
      default_endpoint = endpoint_stub.create!(:role => "default", :resource_type => "ExtManagementSystem", :resource_id => vmware_infra.id, :verify_peer => 0)

      migrate

      expect(default_endpoint.reload).to have_attributes(:verify_peer => 1)
    end
  end
end
