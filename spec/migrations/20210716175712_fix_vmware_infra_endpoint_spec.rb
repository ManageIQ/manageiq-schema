require_migration

RSpec.describe FixVmwareInfraEndpoint do
  let(:ems_stub)      { migration_stub(:ExtManagementSystem) }
  let(:endpoint_stub) { migration_stub(:Endpoint) }

  migration_context :up do
    it "sets existing nil ports to 443" do
      vmware_infra     = ems_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager")
      default_endpoint = endpoint_stub.create!(:role => "default", :resource_type => "ExtManagementSystem", :resource_id => vmware_infra.id, :port => nil)

      migrate

      expect(default_endpoint.reload).to have_attributes(:port => 443)
    end

    it "doesn't change existing ports" do
      vmware_infra     = ems_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager")
      default_endpoint = endpoint_stub.create!(:role => "default", :resource_type => "ExtManagementSystem", :resource_id => vmware_infra.id, :port => 8443)

      migrate

      expect(default_endpoint.reload).to have_attributes(:port => 8443)
    end
  end

  migration_context :down do
    it "set port to nil" do
      vmware_infra     = ems_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager")
      default_endpoint = endpoint_stub.create!(:role => "default", :resource_type => "ExtManagementSystem", :resource_id => vmware_infra.id, :port => 443)

      migrate

      expect(default_endpoint.reload).to have_attributes(:port => nil)
    end
  end
end
