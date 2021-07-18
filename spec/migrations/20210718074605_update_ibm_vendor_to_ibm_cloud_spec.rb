require_migration

RSpec.describe UpdateIbmVendorToIbmCloud do
  let(:vm_stub) { migration_stub(:Vm) }

  migration_context :up do
    it "updates vendor to 'ibm_cloud' for IBM Cloud managers" do
      vpc_vm = vm_stub.create!(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager::Vm", :vendor => "ibm")
      powervs_vm = vm_stub.create!(:type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Vm", :vendor => "ibm")

      migrate

      expect(vpc_vm.reload).to have_attributes(:vendor => "ibm_cloud")
      expect(powervs_vm.reload).to have_attributes(:vendor => "ibm_cloud")
    end
  end

  migration_context :down do
    it "reverts vendor to 'ibm' for IBM Cloud managers" do
      vpc_vm = vm_stub.create!(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager::Vm", :vendor => "ibm_cloud")
      powervs_vm = vm_stub.create!(:type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Vm", :vendor => "ibm_cloud")

      migrate

      expect(vpc_vm.reload).to have_attributes(:vendor => "ibm")
      expect(powervs_vm.reload).to have_attributes(:vendor => "ibm")
    end
  end
end
