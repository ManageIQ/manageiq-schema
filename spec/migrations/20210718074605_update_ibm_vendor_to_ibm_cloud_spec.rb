require_migration

RSpec.describe UpdateIbmVendorToIbmCloud do
  let(:vm_stub) { migration_stub(:VmOrTemplate) }

  migration_context :up do
    it "updates vendor to 'ibm_cloud' for IBM Cloud managers" do
      vpc_vm = vm_stub.create!(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager::Vm", :vendor => "ibm")
      vpc_template = vm_stub.create!(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager::Template", :vendor => "ibm")

      powervs_vm = vm_stub.create!(:type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Vm", :vendor => "ibm")
      powervs_template = vm_stub.create!(:type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Template", :vendor => "ibm")

      powervc_vm = vm_stub.create!(:type => "ManageIQ::Providers::IbmPowerVc::CloudManager::Vm", :vendor => "ibm_power_vc")
      powervc_template = vm_stub.create!(:type => "ManageIQ::Providers::IbmPowerVc::CloudManager::Template", :vendor => "ibm_power_vc")

      openstack_vm = vm_stub.create!(:type => "ManageIQ::Providers::Openstack::CloudManager::Vm", :vendor => "ibm")
      openstack_template = vm_stub.create!(:type => "ManageIQ::Providers::Openstack::CloudManager::Template", :vendor => "ibm")

      migrate

      expect(vpc_vm.reload).to have_attributes(:vendor => "ibm_cloud")
      expect(vpc_template.reload).to have_attributes(:vendor => "ibm_cloud")

      expect(powervs_vm.reload).to have_attributes(:vendor => "ibm_cloud")
      expect(powervs_template.reload).to have_attributes(:vendor => "ibm_cloud")

      expect(powervc_vm.reload).to have_attributes(:vendor => "ibm_power_vc")
      expect(powervc_template.reload).to have_attributes(:vendor => "ibm_power_vc")

      expect(openstack_vm.reload).to have_attributes(:vendor => "ibm")
      expect(openstack_template.reload).to have_attributes(:vendor => "ibm")
    end
  end

  migration_context :down do
    it "reverts vendor to 'ibm' for IBM Cloud managers" do
      vpc_vm = vm_stub.create!(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager::Vm", :vendor => "ibm_cloud")
      vpc_template = vm_stub.create!(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager::Template", :vendor => "ibm_cloud")

      powervs_vm = vm_stub.create!(:type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Vm", :vendor => "ibm_cloud")
      powervs_template = vm_stub.create!(:type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Template", :vendor => "ibm_cloud")

      powervc_vm = vm_stub.create!(:type => "ManageIQ::Providers::IbmPowerVc::CloudManager::Vm", :vendor => "ibm_power_vc")
      powervc_template = vm_stub.create!(:type => "ManageIQ::Providers::IbmPowerVc::CloudManager::Template", :vendor => "ibm_power_vc")

      openstack_vm = vm_stub.create!(:type => "ManageIQ::Providers::Openstack::CloudManager::Vm", :vendor => "ibm")
      openstack_template = vm_stub.create!(:type => "ManageIQ::Providers::Openstack::CloudManager::Template", :vendor => "ibm")

      migrate

      expect(vpc_vm.reload).to have_attributes(:vendor => "ibm")
      expect(vpc_template.reload).to have_attributes(:vendor => "ibm")

      expect(powervs_vm.reload).to have_attributes(:vendor => "ibm")
      expect(powervs_template.reload).to have_attributes(:vendor => "ibm")

      expect(powervc_vm.reload).to have_attributes(:vendor => "ibm_power_vc")
      expect(powervc_template.reload).to have_attributes(:vendor => "ibm_power_vc")

      expect(openstack_vm.reload).to have_attributes(:vendor => "ibm")
      expect(openstack_template.reload).to have_attributes(:vendor => "ibm")
    end
  end
end
